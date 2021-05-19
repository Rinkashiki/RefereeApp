class ActivitiesController < ApplicationController

	# Render navigation bar  
    layout 'in_session', only: [ :index, :new, :show, :edit, :destroy, :add_question, :my_activities, :activity_users, 
                                :add_activity_user, :activity_questions, :edit_activity_user]

    # Check user is logged
    before_action :authorized

    skip_before_action :verify_authenticity_token, only: [ :update_activity_user]

    # Extract the current activity before any method is executed
    before_action :set_activity, only: [ :show, :edit, :update, :destroy, :add_question, :quit_activity_question, :add_activity_user, 
                                        :add_activity_user_post, :activity_users, :quit_activity_user, :activity_questions,
                                        :edit_activity_user, :update_activity_user]

    before_action :set_user, only: [ :quit_activity_user, :add_activity_user_post, :edit_activity_user, :update_activity_user]                                    

    def index
        @activities = Activity.where(responsible: helpers.current_user[ :name])
    end

    def new
        @activity = Activity.new
    end

    def create

        # Extract only the activities associated with the current user
        aux_activity = Activity.find_by_name(params[ :activity][ :name])
        activities = Activity.where(responsible: helpers.current_user[ :name])

        if !aux_activity.in?(activities)
          @activity = Activity.new activity_params
          @activity[ :initial_date] = Time.now
          @activity[ :final_date] = Time.now
          @activity[ :result_date] = Time.now
          @activity[ :grade] = 5
          @activity[ :responsible] = helpers.current_user[ :name]

          # Save activity in DB
          if @activity.save
            flash[ :alert] = "Succesfully created activity"
            redirect_to activities_path
          else
            flash[ :alert] = @activity.errors.first.full_message
            redirect_to new_activity_path
          end
        else
            flash[ :alert] = "Activity name already used in another existing activity"
            redirect_to new_activity_path
        end    
    end

    def show
    end

    def edit
    end

    def update
      @activity.update(initial_date: params[ :activity][ :initial_date], final_date: params[ :activity][ :final_date], 
      result_date: params[ :activity][ :result_date], grade: params[ :activity][ :grade])

      query = "UPDATE activities_users SET user_initial_date = '#{@activity.initial_date.to_date}', 
      user_final_date = '#{@activity.final_date.to_date}', user_result_date = '#{@activity.result_date.to_date}'
      WHERE activity_id = '#{@activity.id}'"

      ActiveRecord::Base.connection.exec_query(query)

      flash[ :alert] = 'Succesfully edited!'

      redirect_to @activity
    end

    def destroy
    @activity.destroy
    flash[ :alert] = 'Successfully deleted activity'
    redirect_to activities_path
    end

    # Activity-Question Association Management
    def activity_questions
      # Extract questions associated with the current activity
      query = "SELECT q.id, q.question, q.question_type FROM questions q JOIN activities_questions aq ON aq.question_id = q.id 
      WHERE aq.activity_id = '#{@activity.id}'"

      @questions = Question.find_by_sql(query)
    end

    def quit_activity_question
      @question = Question.find params[ :question]

      query = "DELETE from activities_questions WHERE activity_id = '#{@activity.id}' AND question_id = '#{@question.id}'"
      ActiveRecord::Base.connection.exec_query(query)
    
      flash[ :alert] = 'Successfully quit question'
    
      redirect_to activity_questions_path

    end

    # Activity-User Association Management
    def activity_users
      query = "SELECT u.id, u.name, u.surname from users u JOIN activities_users au ON u.id = au.user_id
      WHERE '#{@activity.id}' = au.activity_id"

      @users = User.find_by_sql(query)
    end

    def add_activity_user
 
      # Extract users not associated with the current activity. Exclude also the current user
      query = "SELECT id, name, surname from users except SELECT u.id, u.name, u.surname from users u 
      JOIN activities_users au ON u.id = au.user_id WHERE '#{@activity.id}' = au.activity_id
      except SELECT id, name, surname from users WHERE id = '#{helpers.current_user[ :id]}'"

      @users = User.find_by_sql(query)
      
    end

    def quit_activity_user

      query = "DELETE from activities_users WHERE activity_id = '#{@activity.id}' AND user_id = '#{@user.id}'"
      ActiveRecord::Base.connection.exec_query(query)
      
      flash[ :alert] = 'Successfully quit user'
      redirect_to activity_users_path
    end

    def add_activity_user_post

      query = "INSERT into activities_users (activity_id, user_id, user_initial_date, user_final_date, user_result_date,
       status, last_question, created_at, updated_at) values ('#{@activity.id}', '#{@user.id}', '#{@activity.initial_date.to_date}',
       '#{@activity.final_date.to_date}', '#{@activity.result_date.to_date}', 'Disponible', 0, now(), now())"
      ActiveRecord::Base.connection.exec_query(query)

      flash[ :alert] = 'Successfully added user'

      redirect_to activity_users_path
    end

    def edit_activity_user
      query = "SELECT * from activities_users WHERE activity_id = '#{@activity[ :id]}' AND 
      user_id = '#{@user.id}'"

      @activity_user = ActiveRecord::Base.connection.exec_query(query).rows
    end

    def update_activity_user

      query = "UPDATE activities_users SET user_initial_date = '#{params[ :user_initial_date]}', 
      user_final_date = '#{params[ :user_final_date]}', user_result_date = '#{params[ :user_result_date]}'
      WHERE activity_id = '#{@activity.id}' AND user_id = '#{@user.id}'"

      ActiveRecord::Base.connection.exec_query(query)

      flash[ :alert] = 'Succesfully edited!'

      redirect_to activity_users_path
    end

    private 

    def activity_params
        params.require( :activity).permit( :name)
    end

    def set_activity
        @activity = Activity.find params[ :id]
    end

    def set_user
      @user = User.find params[ :user]
    end
    
end
