class QuestionsController < ApplicationController

	# Render navigation bar
    layout 'in_session', only: [ :index, :new, :show]

    # Check user is logged
    before_action :authorized

    # Extract the current question before any method is executed
    before_action :set_question, only: [ :show, :add_activity_question, :add_clip_question]

    def index
        @questions = Question.all
    end

    def new

        if !params[ :activity].nil?
          # Question created from activity
          @activity = Activity.find params[ :activity]

          # Extract questions that are not associated with the current activity. For existing questions section
          query = "SELECT id, question, question_type from questions except 
          SELECT q.id, q.question, q.question_type from questions q join activities_questions aq on 
          q.id = aq.question_id where aq.activity_id = '#{@activity.id}'"
  
          @questions = Question.find_by_sql(query)

           # Extract all clips. For Video Trivia section
          @clips = Clip.all

          # Extract clips with decision and sanction present. For Video Test section
          @evaluated_clips = Clip.where.not(decision_id: nil, sanction_id: nil)

        else 
          # Questions created from clip
          @questions = Question.where(question_type: "Trivia")
        end

        # Every question
        @question = Question.new 

        @type = params[ :type]

        if !params[ :clip].nil?
          @clip = params[ :clip]
        end

        respond_to :html, :js
    end

    def create

      # Question created from activity
      if !params[ :activity].nil?
        @activity = Activity.find params[ :activity]
      end

      # Question created from clip
      if !params[ :clip].nil?
        @clip = Clip.find params[ :clip]
      end

      # Create question
      @question = Question.new question_params

      # Established default question for Video Test because it has not question field
      if params[ :type] == "Video Test"
        @question[ :question] = "Video Test"
      end

      # Determine question type
        @question[ :question_type] = params[ :type]

        if !@clip.nil?
          @question[ :clip_id] = params[ :clip]

          if @question[ :question_type] != "Video Test"
            @question[ :question_type] = "Video Trivia" 
          end
        end
        
        if @question.save
            flash[ :alert] = "Succesfully created question"
            
            if !params[ :activity].nil?
              # Question created from activity
              query = "INSERT into activities_questions (activity_id, question_id, created_at, updated_at) 
              values ('#{@activity.id}', '#{@question.id}', DateTime('now'), DateTime('now'))"
              ActiveRecord::Base.connection.exec_query(query)

              redirect_to activity_questions_path(id: params[ :activity])
            else
              # Question created from clip
              @clip.update(question_id: @question[ :id])

              redirect_to @clip
            end
        else
            flash[ :alert] = @question.errors.first.full_message
            if !params[ :activity].nil?
              redirect_to new_question_path(activity: params[ :activity], type: params[ :type])
            else
              redirect_to new_question_path(clip: params[ :clip], type: params[ :type])
            end
        end
        
        #respond_to do |format|
        #format.js {render layout: false, content_type: 'text/javascript'}
        #format.html
      #end

    end

    def show

        @answers = Answer.where(question_id: @question[ :id])

        # Show question from clip
        if !@question[ :clip_id].nil?
          @clip = Clip.find(@question[ :clip_id])

          # Show decision and sanction if question is Video Test type
          if !@clip[ :decision_id].nil?
            @decision = Decision.find(@clip[ :decision_id])
          end
          if !@clip[ :sanction_id].nil?
            @sanction = Sanction.find(@clip[ :sanction_id])
          end
        end
    end

    def add_activity_question

      @activity = Activity.find params[ :activity]

      # Associate selected question with the current activity
      query = "INSERT into activities_questions (activity_id, question_id, created_at, updated_at) 
      values ('#{@activity.id}', '#{@question.id}', DateTime('now'), DateTime('now'))"

      ActiveRecord::Base.connection.exec_query(query)

      flash[ :alert] = 'Successfully added question'
      redirect_to activity_questions_path(@activity.id)

    end

    def add_clip_question

      @clip = Clip.find params[ :clip]

      # Associate selected question with the current clip
      @clip.update(question_id: @question[ :id])
 
       flash[ :alert] = 'Successfully added question'
       redirect_to @clip

    end

    private

    def question_params
        params.require( :question).permit( :question, :response_time)
    end

    def set_question
      @question = Question.find params[ :id]
    end
    
end
