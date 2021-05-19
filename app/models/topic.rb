class Topic < ApplicationRecord

	validates :description, presence: true

    has_and_belongs_to_many :clips
    
end
