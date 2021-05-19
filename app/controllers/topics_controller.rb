class TopicsController < ApplicationController

	# Render navigation bar
    layout 'in_session', only: [ :new, :index, :edit]

    # Check user is logged
    before_action :authorized 

    # Extract the current topic before any method is executed
    before_action :set_topic, only: [ :edit, :update, :show, :destroy]

    def index
        @topics = Topic.all
    end

    def new
        @topic = Topic.new
    end

    def create
        @topic = Topic.new topic_params

        respond_to do |format|
            if @topic.save
                @notification = 'Succesfully posted topic!'
            else
                @notification = @topic.errors.first.full_message
            end

            format.js
        end
    end

    def show
    end

    def edit
    end

    def update
        @topic.update topic_params
        flash[ :alert] = 'Succesfully edited!'
        redirect_to topics_path
    end

    def destroy
        @topic.destroy
        flash[ :alert] = 'Succesfully deleted topic'
        redirect_to topics_path
    end

    private

    def topic_params
        params.require( :topic).permit( :description)
    end

    def set_topic
        @topic = Topic.find params[ :id]
    end
    
end
