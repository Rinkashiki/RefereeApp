class User < ApplicationRecord

	validates :name, :surname, presence: true
  	validates :email, presence: true, uniqueness: true

  	belongs_to :profile

  	has_and_belongs_to_many :activities

end
