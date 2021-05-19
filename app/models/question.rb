class Question < ApplicationRecord

	validates :question, presence: true

    has_one :clip

    has_many :answers
    
    has_and_belongs_to_many :activities
    
end
