class Answer < ApplicationRecord

	validates :description, presence: true

    belongs_to :question
    
end
