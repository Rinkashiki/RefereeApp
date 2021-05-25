class ClipsController < ApplicationController

	# Render navigation bar
  layout 'in_session', only: [ :index, :show, :edit, :add_topic ]

  # Check user is logged
  before_action :authorized 

  # Extract the current clip before any method is executed
  before_action :set_clip, only: [ :show, :destroy, :update_decision, :update_sanction, :add_topic, :add_topic_post, :quit_topic,
   :quit_question]
  
  def index
    @clips = Clip.all

    respond_to :html, :js
  end

  def new
    @clip = Clip.new
  end

  def create

  params[ :videos].each do |v|

    @clip = Clip.new(video: v)
  
    @clip[ :clipName] = File.basename(v.original_filename, '.mp4').truncate(20)
    @clip[ :uploadUser] = helpers.current_user[ :name]

    @clip.save

  end

  flash[ :alert] = 'Successfully uploaded video/s'
  redirect_to clips_path

    # Save clip in DB
    #if @clip.save
      #flash[ :alert] = 'Successfully uploaded video'
      #redirect_to clips_path
    #else
      #flash[ :alert] = @clip.errors.first.full_message
      #redirect_to clips_path
    #end

  end 

  def show
    if !@clip[ :decision_id].nil?
      @decision = Decision.find(@clip[ :decision_id])
    end
    if !@clip[ :sanction_id].nil?
      @sanction = Sanction.find(@clip[ :sanction_id])
    end
    
    # Show only the topics associated with the current clip
    query = "SELECT t.id, t.description FROM topics t JOIN clips_topics ct ON ct.topic_id = t.id WHERE ct.clip_id = '#{@clip.id}'"

    @topics = ActiveRecord::Base.connection.exec_query(query)

    # Show questions and answers for current clip
    if !@clip[ :question_id].nil?
      @question = Question.find @clip[ :question_id]
    end

    if !@question.nil?
      @answers = Answer.where(question_id: @question[ :id])
    end
  end

  def edit_decision
    @decisions = Decision.all
  end

  def edit_sanction
    @sanctions = Sanction.all
  end

  def update_decision
    @decision = Decision.find_by_description(params[ :decision])

    @clip.update(decision_id: @decision[ :id])

    flash[ :alert] = 'Succesfully edited decision!'
    redirect_to @clip

    #@notification = 'Succesfully edited decision'
    #respond_to :js
  end

  def update_sanction
    @sanction = Sanction.find_by_description(params[ :sanction])

    @clip.update(sanction_id: @sanction[ :id])

    flash[ :alert] = 'Succesfully edited sanction'
    redirect_to @clip

    #@notification = 'Succesfully edited sanction'
    #respond_to :js
  end

  def destroy
    folder_id = @clip[ :id]
    @clip.destroy
    FileUtils.remove_dir "#{Rails.public_path}/uploads/clip/video/#{folder_id}", true
    flash[ :alert] = 'Successfully deleted clip'
    redirect_to clips_path
  end

  def add_topic
    # Show only the topics that are not associated with the current clip
    query = "SELECT topics.id, topics.description from topics except 
    SELECT t.id, t.description from topics t join clips_topics ct on t.id = ct.topic_id where ct.clip_id = '#{@clip.id}'"

    @topics = ActiveRecord::Base.connection.exec_query(query)
  end

  def add_topic_post
    @topic = Topic.find params[ :topic]

    query = "INSERT into clips_topics (clip_id, topic_id, created_at, updated_at) 
    values ('#{@clip.id}', '#{@topic.id}', DateTime('now'), DateTime('now'))"

    ActiveRecord::Base.connection.exec_query(query)

    flash[ :alert] = 'Successfully added topic'
    redirect_to clip_path

  end

  def quit_topic
    @topic = Topic.find params[ :topic]

    query = "DELETE from clips_topics WHERE clip_id = '#{@clip.id}' AND topic_id = '#{@topic.id}'"
    ActiveRecord::Base.connection.exec_query(query)
    
    flash[ :alert] = 'Successfully quit topic'
    redirect_to clip_path
  end

  def quit_question

    @clip.update(question_id: nil)
    
    flash[ :alert] = 'Successfully quit question'
    
    redirect_to clip_path
  end

  private 

  def clip_params
    params.require( :clip).permit( :video)
  end

  def set_clip
    @clip = Clip.find params[ :id]
  end

  # Exception rised when the user is trying to upload video without attached one
  rescue_from ActionController::ParameterMissing do |e|
    flash[ :alert] = 'Video not attached'
    redirect_to new_clip_path
  end
  
end
