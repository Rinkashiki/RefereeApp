class ActivitiesUsersController < ApplicationController

	# Render navigation bar  
    layout 'in_session', only: [ :index, :finish_activity]

    # Check user is logged
    before_action :authorized 

    skip_before_action :verify_authenticity_token, only: [ :doing_activity_post]

    # Extract the current activity before any method is executed
    before_action :set_activity, only: [ :doing_activity, :doing_activity_post, :finish_activity, :reset_activity]

      def index

        # For paused activity
        if !params[ :activity].nil?
          # Update activity_user status and last_question
          query = "UPDATE activities_users SET status = 'Pausada' WHERE activity_id = '#{params[ :activity]}' 
          AND user_id = '#{helpers.current_user[ :id]}'"

          ActiveRecord::Base.connection.exec_query(query)   
        end

        query = "SELECT a.* from activities a JOIN activities_users au ON a.id = au.activity_id 
        where '#{helpers.current_user[ :id]}' = au.user_id"
  
        @activities = Activity.find_by_sql(query)

        query = "SELECT * from activities_users WHERE user_id = '#{helpers.current_user[ :id]}' ORDER BY activity_id"

        @activities_user = ActiveRecord::Base.connection.exec_query(query)

      end

      def doing_activity

        # For prevent going back while doing an activity. Delete answers.
        query = "SELECT * from activities_users WHERE activity_id = '#{@activity[ :id]}' AND 
        user_id = '#{helpers.current_user[ :id]}' ORDER BY activity_id"

        activity_user = ActiveRecord::Base.connection.exec_query(query)

        @n_question = params[ :n_question].to_i

        if @n_question < activity_user[0]['last_question']
          ##########Actualizar numero de tries##############
          #redirect_to reset_activity_path(activity: @activity.id)

          redirect_to activities_users_path(activity: @activity.id)
        else
          # For all questions
          query = "SELECT q.* from questions q JOIN activities_questions aq ON q.id = aq.question_id 
          where aq.activity_id = '#{@activity[ :id]}'"
          questions = Question.find_by_sql(query)

          @total_questions = questions.length()
        
          @question = questions[@n_question] 

          @type = @question[ :question_type]

          # Extract answers of the current question
          @answers = Answer.where(question_id: @question.id)

          # For Video Trivia and Video Test
          if !@question.clip_id.nil?
            @clip = Clip.find(@question.clip_id)
          end
        end

      end

      def doing_activity_post

        # Extract question count 
        query = "SELECT q.* FROM questions q JOIN activities_questions aq ON q.id = aq.question_id 
        where aq.activity_id = '#{@activity[ :id]}'"
        questions = Question.find_by_sql(query)

        total_questions = questions.length()

        @n_question = params[ :n_question].to_i

        @question = questions[@n_question]

        # Extract the activity_user entry
        query = "SELECT * from activities_users WHERE activity_id = '#{@activity[ :id]}' 
        AND user_id = '#{helpers.current_user[ :id]}'"

        activity_user = ActiveRecord::Base.connection.exec_query(query)
    
        # Save the answer associated with the activity and the user in DB. For Trivia and Video Trivia
        if @question.question_type == "Trivia" || @question.question_type == "Video Trivia"
          if !params[ :answers_ids].nil?
            query = "INSERT into activity_user_answers (activities_users_id, answers, created_at, updated_at) 
            values ('#{activity_user[0]['id']}', '#{params[ :answers_ids]}', DateTime('now'), DateTime('now'))"
          else
            query = "INSERT into activity_user_answers (activities_users_id, created_at, updated_at) 
            values ('#{activity_user[0]['id']}', DateTime('now'), DateTime('now'))"
          end

          ActiveRecord::Base.connection.exec_query(query)
        end

        # Save the decision and sanction associated with the activity and the user in DB. For Video Test
        if @question.question_type == "Video Test"
          if !params[ :user_decision].nil? && !params[ :user_sanction].nil?
            query = "INSERT into activity_user_answers (activities_users_id, decision_id, sanction_id, created_at, updated_at) 
            values ('#{activity_user[0]['id']}', '#{params[ :user_decision]}', '#{params[ :user_sanction]}', DateTime('now'), DateTime('now'))"
          elsif params[ :user_decision].nil? && !params[ :user_sanction].nil?
            query = "INSERT into activity_user_answers (activities_users_id, sanction_id, created_at, updated_at) 
            values ('#{activity_user[0]['id']}', '#{params[ :user_sanction]}', DateTime('now'), DateTime('now'))"
          elsif !params[ :user_decision].nil? && params[ :user_sanction].nil?
            query = "INSERT into activity_user_answers (activities_users_id, decision_id, created_at, updated_at) 
            values ('#{activity_user[0]['id']}', '#{params[ :user_decision]}', DateTime('now'), DateTime('now'))"
          else
            query = "INSERT into activity_user_answers (activities_users_id, created_at, updated_at) 
            values ('#{activity_user[0]['id']}', DateTime('now'), DateTime('now'))"
          end

          ActiveRecord::Base.connection.exec_query(query)
        end

        # Save the open_question associated with the activity and the user in DB. For Open Question
        if @question.question_type == "Pregunta Abierta"
          if !params[ :open_question].nil?
            query = "INSERT into activity_user_answers (activities_users_id, open_question, created_at, updated_at) 
            values ('#{activity_user[0]['id']}', '#{params[ :open_question]}', DateTime('now'), DateTime('now'))"
          else
            query = "INSERT into activity_user_answers (activities_users_id, created_at, updated_at) 
            values ('#{activity_user[0]['id']}', DateTime('now'), DateTime('now'))"
          end

          ActiveRecord::Base.connection.exec_query(query)
        end

        if @n_question < total_questions - 1 
          # Update last_question in activity_user entry
          query = "UPDATE activities_users SET last_question = '#{@n_question + 1}' WHERE activity_id = '#{params[ :activity]}' AND  
          user_id = '#{helpers.current_user[ :id]}'"

          ActiveRecord::Base.connection.exec_query(query)

          redirect_to doing_activity_path(activity: @activity.id, n_question: @n_question + 1)
        else
          if Time.now.strftime("%d/%m/%Y") >= @activity.result_date.strftime("%d/%m/%Y")
            redirect_to finish_activity_path(activity: @activity.id)
          else
            redirect_to activities_users_path
          end
        end

      end

      def finish_activity

        # Extract questions
        query = "SELECT q.* from questions q JOIN activities_questions aq ON q.id = aq.question_id 
        where aq.activity_id = '#{@activity[ :id]}'"
        
        @questions = Question.find_by_sql(query)

        #Extract activity_user_answers entries
        query = "SELECT aua.* FROM activity_user_answers aua JOIN activities_users au
        ON aua.activities_users_id = au.id WHERE au.activity_id = '#{@activity[ :id]}' AND 
        au.user_id = '#{helpers.current_user[ :id]}'"

        @user_answers = ActiveRecord::Base.connection.exec_query(query)

        #### Grade calculation ####

        # Update activity_user status and grade
        query = "UPDATE activities_users SET status = 'Finalizada', user_grade = 5 WHERE activity_id = '#{@activity[ :id]}' AND  
        user_id = '#{helpers.current_user[ :id]}'"

        ActiveRecord::Base.connection.exec_query(query)

        # Extract decisions and sanctions from questions
        @decisions = Array.new
        @sanctions = Array.new

        @questions.each do |q|
          if !q.clip_id.nil?
            clip = Clip.find(q.clip_id)
            @decisions.push(clip.decision_id)
            @sanctions.push(clip.sanction_id)
          else
            @decisions.push(nil)
            @sanctions.push(nil)
          end
        end

      end

      private 

      def set_activity
        @activity = Activity.find params[ :activity]
      end

end
