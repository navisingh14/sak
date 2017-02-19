class UserAuth < ActiveRecord::Base
	belongs_to :user

	validates :uid, :provider,:user_id, :presence => true
	validates_length_of :uid, :maximum => 255
	validates_length_of :provider, :maximum => 255
end
