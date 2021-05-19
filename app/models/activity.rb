class Activity < ApplicationRecord

	validates :name, :responsible, :grade, presence: true

    has_and_belongs_to_many :users

    has_and_belongs_to_many :questions
    
end
