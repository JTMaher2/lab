class Listing < ActiveRecord::Base
	has_many :comments, dependent: :destroy
  	validates :address, presence: true,
  	length: {minimum: 5}
end