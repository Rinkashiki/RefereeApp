class ImagesController < ApplicationController

	before_action :set_image, only: [ :show]

	def index
		@images = Image.all
	end

	def new
		@image = Image.new
	end

	def create
		@image = Image.new image_params

		respond_to do |format|
			if @image.save
        		format.js
        	end
        end
	end

	def show
	end

	private 

	def image_params
        params.require( :image).permit( :name, :description)
    end

    def set_image
        @image = Image.find params[ :id]
    end
end
