require 'spec_helper'

describe UsersController, :type => :controller do

	describe "handling requests for user_signup" do
		handle_session
		it "should not respond to get request" do
			get :user_signup
			expect(response.code).to eq('406')
		end

		it "should not respond to simple post request" do
			post  :user_signup
			expect(response.code).to eq('406')
		end

	end

	describe "testing user login" do
		handle_session
		it "should not respond to get request" do
			get :user_signin
			expect(response.code).to eq('406')
		end

		it "should not respond to simple post request" do
			post  :user_signin
			expect(response.code).to eq('406')
		end

		it "should login a user with valid credentials" do
			sign_out(subject.current_user)
			user = User.new FactoryGirl.attributes_for(:user)
			user.firstname = 'firstname'
			user.lastname = 'lastname'
			user.email = "testing@credihealth.com"
			user.password = 'new life'
			user.save
			xhr :post, :user_signin, user: {email: user.email,password: user.password }
			expect(response.code).to eq('200')
			expect(response.body).to include("message","Sign in","successful")
		end

		it "should log out current user if new user tries to login and sign in new user" do
			signedid = subject.current_user.id
			user = User.new FactoryGirl.attributes_for(:user)
			user.firstname = 'firstname'
			user.lastname = 'lastname'
			user.email = "testing@credihealth.com"
			user.password = 'new life'
			user.save
			xhr :post, :user_signin, user: {email: user.email,password: user.password }
			expect(response.code).to eq('200')
			expect(response.body).to include("message","Sign in","successful")
		end

		it "should respond with password invalid for user with invalid password" do
			sign_out(subject.current_user)
			user = User.new FactoryGirl.attributes_for(:user)
			user.firstname = 'firstname'
			user.lastname = 'lastname'
			user.email = "testing@credihealth.com"
			user.password = 'new life'
			user.save
			xhr :post, :user_signin, user: {email: user.email,password: user.password+"123" }
			expect(response.code).to eq('200')
			expect(response.body).to include("message","Password","invalid")
		end
	end

	describe "get logged in user" do
		handle_session
		it "should return user if current user exist" do
			xhr :get, :logged_in, :format => :json
			expect(response.code).to eq('200')
			expect(response.body).to include("id","firstname","lastname","email")
		end

		it "should return nothing if current user does not exist" do
			sign_out(subject.current_user)
			xhr :get, :logged_in, :format => :json
			expect(response.code).to eq('200')
			expect(response.body).to include("message","Nobody logged In")
		end
	end

	describe "creating User on XHR requests" do
		handle_session
		it "should create User with valid params in the XHR request" do
			expect{
				xhr :post, :user_signup, user: { firstname: "Test", lastname: "User", email: "te@gmail.com", password: "12345678"}
			}.to change(User, :count).by(1)
			expect(response.code).to eq('200')

		end

		it "should not create User with invalid email in the XHR request" do
			expect{
				xhr :post, :user_signup, user: { firstname: "Test", lastname: "User", email: "tegmailcom", password: "12345678"}
			}.to change(User, :count).by(0)
			expect(response.code).to eq('200')
			expect(response.body).to include("email","invalid")
		end

		it "should not create User with invalid password in the XHR request" do
			expect{
				xhr :post, :user_signup, user: { firstname: "Test", lastname: "User", email: "te@gmail.com", password: "123"}
			}.to change(User, :count).by(0)
			expect(response.code).to eq('200')
			expect(response.body).to include("password","too short")
		end

	end

	describe "User resend confirmations instrutions" do
		handle_session

		it "should respond with Already Confirmed if user is confirmed" do
			sign_out(subject.current_user)
			user = User.new FactoryGirl.attributes_for(:user)
			user.firstname = 'firstname'
			user.lastname = 'lastname'
			user.email = "testing@credihealth.com"
			user.password = 'new life'
			user.save!
			user.confirm
			sign_in(:user,user)
			xhr :get,:resend_confirmation
			expect(response.code).to eq('200')
			expect(response.body).to include("message","Already Confirmed")
		end

		it "should respond with Sent if user is not confirmed and confirmation instructions resent" do
			sign_out(subject.current_user)
			user = User.new FactoryGirl.attributes_for(:user)
			user.firstname = 'firstname'
			user.lastname = 'lastname'
			user.email = "testing@credihealth.com"
			user.password = 'new life'
			user.save!
			previousConfrmTime = user.confirmation_sent_at
			sleep 2
			sign_in(:user,user)
			xhr :get,:resend_confirmation
			expect(response.code).to eq('200')
			expect(response.body).to include("message","Sent")
			expect(subject.current_user.confirmation_sent_at).not_to eql(previousConfrmTime)
		end

	end

end