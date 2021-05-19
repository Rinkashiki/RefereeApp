class EvaluationController < ApplicationController

	# Render navigation bar  
    layout 'in_session', only: [ :index, :results, :user_results]

    before_action :set_activity, only: [ :results, :user_results]

    # Check user is logged
    before_action :authorized

    def index
        @activities = Activity.all
    end

    def results
        query = "SELECT * FROM activities_users WHERE activity_id = '#{@activity.id}'" 
        @activities_users = ActiveRecord::Base.connection.exec_query(query)

        query = "SELECT u.* FROM users u JOIN activities_users au ON u.id = au.user_id WHERE au.activity_id = '#{@activity.id}'"
        @users = ActiveRecord::Base.connection.exec_query(query)
    end

    def user_results
        @user = User.find params[ :user]

        @correct_answers = []

        # Extract questions
        query = "SELECT q.* from questions q JOIN activities_questions aq ON q.id = aq.question_id 
        where aq.activity_id = '#{@activity[ :id]}'"
        
        @questions = Question.find_by_sql(query)

        #Extract activity_user_answers entries
        query = "SELECT aua.* FROM activity_user_answers aua JOIN activities_users au
        ON aua.activities_users_id = au.id WHERE au.activity_id = '#{@activity.id}' AND 
        au.user_id = '#{@user.id}'"

        @user_answers = ActiveRecord::Base.connection.exec_query(query)

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
