class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable , :confirmable

	has_many :user_auths, :dependent => :destroy

	validates :firstname, :lastname, :presence => true

	validates_length_of :email, :maximum => 255
	validates_length_of :encrypted_password, :maximum => 255
	validates_length_of :reset_password_token, :maximum => 255
	validates_length_of :current_sign_in_ip, :maximum => 255
	validates_length_of :last_sign_in_ip, :maximum => 255
	validates_length_of :firstname, :maximum => 255
	validates_length_of :lastname, :maximum => 255
	validates_length_of :confirmation_token, :maximum => 255
	validates_length_of :unconfirmed_email, :maximum => 255

	before_validation :strip_whitespaces

	def strip_whitespaces
		self.firstname = self.firstname.strip if !self.firstname.nil?
		self.email = self.email.strip if !self.email.nil?
		self.lastname = self.lastname.strip if !self.lastname.nil?
	end

end
