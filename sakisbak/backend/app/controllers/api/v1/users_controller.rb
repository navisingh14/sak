class Api::V1::UsersController < ApplicationController
	require 'oauth'
	require 'nokogiri'

	def show                                    #sends back the user if the user requesting the record is same as the user loggedin
		@user = User.find(params[:id])
		render json:{:user =>  @user}, status: :ok
	end

	def logged_in
		#This method will return the current logged in user if there is any.
		respond_to do |format|
			if current_user
				format.json {render json:{user: current_user}}
			else
				format.json {render json: {:message => "Nobody logged In"},status: :ok}
			end
		end
	end

	def user_signin
		#This method will handle the sign in of a user through an ajax request.
		#The user from the frontend will enter his/her credentials in the modal. The Ember app will then make an ajax request to our rails app
		#with the data entered by the user. Then we will authenticate the user through devise and set the current_user.
		# If successfully authenticated we will respond with the user_id to the frontend otherwise we will respond with errors
		# encountered.
		if request.method != 'POST' or !request.xhr?
			render json:{},:status => :not_acceptable
		else
			sign_out(current_user) if current_user
			user = User.find_by_email(params[:user][:email])
			if user.nil?
				respond_to do |format|
					format.json {render json: {:message => "Sorry this User does not exist."}}
				end
			else
				if user.valid_password?(params[:user][:password])      #Check the password validtity
					sign_in(:user, user)                                #Sign in the user
					if current_user
						respond_to do |format|
							format.json {render json: {:message => "Sign in successful"}}
						end
					end
				else
					respond_to do |format|
						format.json {render json: {:message => "Password  invalid"}}
					end
				end
			end
		end
	end

	def user_signup
		#This method will handle the user sign up through an ajax request.
		#The user from the frontend will enter details in the modal. The Ember app will then make an ajax request to our rails app
		#with the data entered by the user. Then we will create the user in this method. If successfully created the response will
		#contain msg with value 1. Otherwise we will send the errors encountered in user model creation in JSON format to frontend.
		#This method assumes all the data validations have been done by the frontend application. Devise also will do another set of
		#validations and checks before creating the user.
		if request.method != 'POST' or !request.xhr?
			render json:{},:status => :not_acceptable
		else
			user = User.new(user_params)
			message_success= {:msg => 1 }
			if user.save
				sign_out(current_user) if current_user
				sign_in(:user, user)
				render json: {:msg => 1}, status: :ok
			else
				errors = user.errors
				render json: errors.messages, status: :ok
			end
		end
	end

	def resend_confirmation
		respond_to do |format|
			if current_user and current_user.confirmed_at.nil?
				current_user.send_confirmation_instructions
				format.json {render json: {:message => "Sent"}}
			else
				if !current_user.confirmed_at.nil?
					format.json {render json: {:message => "Already Confirmed"}}
				end
			end
		end
	end

	def forgot_password
		user = User.find_by_email(params[:email])
		respond_to do |format|
			if !user.nil? and user.send_reset_password_instructions
				format.json {render json: {:message => "Password reset instructions have been sent to the email."}}
			else
				format.json {render json: {:message => "User does not exist."}}
			end
		end
	end

	def change_password
		if params[:user]
			if current_user.valid_password? params[:user][:oldPassword]
				current_user.password=params[:user][:newPassword]
				#current_user.reset_password_token=User.reset_password_token
				current_user.reset_password_sent_at = Time.now
				if current_user.save
					#Whenever user changes password we recompute the md5hash so that previous hashes stored on devices don't work.
					#current_user.generate_md5hash
					#Notifier.delay.change_password(current_user)
					respond_to do |format|
						format.json {render json: {:status=>"Password change successful. Please login again with new password."}}
					end
				else
					respond_to do |format|
						format.json {render json: {:status=>"There was some error on our side. Please try again later."}}
					end
				end
			else
				respond_to do |format|
					format.json {render json: {:status=>"It seems you entered the wrong old password"}}
				end
			end

		else
			respond_to do |format|
				format.json {render :json => {:status=>"Error:Not a valid User"} }
			end
		end

	end


	def facebook
		if params[:access_token].nil?
			@user={'status'=>'error'}
			respond_to do |format|
				format.json {render :json=> @user}
			end
		else
			token=params[:access_token]

			uri = URI.parse('https://graph.facebook.com/me')
			args = {:access_token=> token,:fields=>'id,first_name,last_name,email'}

			uri.query = URI.encode_www_form(args)
			http = Net::HTTP.new(uri.host, uri.port)
			http.use_ssl = true
			begin
				request = Net::HTTP::Get.new(uri.request_uri)
				response = http.request(request)

				if response.nil?
					@user={'status'=>'error'}
					respond_to do |format|
						format.json {render :json=> @user}
					end
					return
				else
					parsed_data= JSON.parse response.body
				end

				unless parsed_data.has_key?('id') and parsed_data.has_key?('email') and parsed_data.has_key?('first_name') and parsed_data.has_key?('last_name')
					raise Exception
				end

			rescue
				@user={'status'=>'error'}
				respond_to do |format|
					format.json {render :json=> @user}
				end
				return
			end

			uid=parsed_data['id']
			email=parsed_data['email'].downcase
			firstname=parsed_data['first_name']
			lastname=parsed_data['last_name']

			@user = get_auth_user(uid,firstname, lastname,email,token,'facebook')
			respond_to do |format|
				format.json {render :json=> @user}
			end
		end
	end

	def google
		if params[:access_token].nil?
			@user={'status'=>'error'}
			respond_to do |format|
				format.json {render :json=> @user}
			end
		else
			token=params[:access_token]
			uri = URI.parse('https://www.googleapis.com/oauth2/v1/userinfo')
			args = {:access_token=> token}
			uri.query = URI.encode_www_form(args)
			http = Net::HTTP.new(uri.host, uri.port)
			http.use_ssl = true
			http.verify_mode = OpenSSL::SSL::VERIFY_NONE

			begin
				request = Net::HTTP::Get.new(uri.request_uri)
				response = http.request(request)

				if response.nil?
					@user={'status'=>'error'}
					respond_to do |format|
						format.json {render :json=> @user}
					end
					return
				else
					parsed_data= JSON.parse response.body
				end

				unless parsed_data.has_key?('id') and parsed_data.has_key?('email')
					raise Exception
				end
				uid=parsed_data['id']
				email=parsed_data['email'].downcase

				uauth=UserAuth.where({:uid=>uid,:provider=>'google'}).first
			rescue => e
				@user={'status'=>'error'}
				respond_to do |format|
					format.json {render :json=> @user}
				end
				return
			end
			if uauth.nil?
				user=User.find_by_email email
				if user.nil?
					quri = URI.parse("https://www.googleapis.com/plus/v1/people/#{uid}?access_token=#{token}")
					#qargs = {:key=> 'AIzaSyA3AogvKKttZlriHJmGqTLnVJa3UWGHT14',:fields=> 'name'}

					#quri.query = URI.encode_www_form(qargs)
					qhttp = Net::HTTP.new(quri.host, quri.port)
					qhttp.use_ssl = true
					qhttp.verify_mode = OpenSSL::SSL::VERIFY_NONE

					qrequest = Net::HTTP::Get.new(quri.request_uri)
					begin
						qresponse = qhttp.request(qrequest)
						if qresponse.nil?
							@user={'status'=>'error'}
							respond_to do |format|
								format.json {render :json=> @user}
							end
							return
						else
							parsed_response=JSON.parse qresponse.body
						end
						unless parsed_response.has_key?('name') and parsed_response['name'].has_key?('givenName') and parsed_response['name'].has_key?('familyName')
							raise Exception
						end
					rescue
						@user={'status'=>'error'}
						respond_to do |format|
							format.json {render :json=> @user}
						end
						return
					end

					firstname=parsed_response['name']['givenName']
					lastname=parsed_response['name']['familyName']

					@user=User.create({:firstname=>firstname,:lastname=>lastname,:email=>email})
					@user.confirm!
				else
					@user=user
				end

				UserAuth.create({:uid=>uid,:provider=>'google',:user_id=>@user.id,:token=>token})
			else
				@user=uauth.user
			end

			sign_out current_user if current_user

			sign_in @user
			respond_to do |format|
				format.json {render :json=> {user: @user}}
			end
		end
	end

	def linkedin
		# extract data from cookie stored in json
		consumer_key = '75291j3don9dv6'
		consumer_secret = 'GwSLgQ7U08Z2yg1T'

		cookie_name = "linkedin_oauth_#{consumer_key}"

		begin
			credentials_json = cookies[cookie_name]
			credentials = JSON.parse(credentials_json)

			jsapi_access_token = credentials['access_token']

			consumer = OAuth::Consumer.new(consumer_key, consumer_secret)

			resp = consumer.request(
					:post,
					'https://api.linkedin.com/uas/oauth/accessToken',
					nil,
					{},
					{'xoauth_oauth2_access_token' => jsapi_access_token}
			)

			oauth1_credentials = CGI.parse(resp.body)
			['oauth_token', 'oauth_token_secret', 'oauth_expires_in', 'oauth_authorization_expires_in'].each do |key|
				oauth1_credentials[key] = oauth1_credentials[key].first
			end

			#puts "Response: #{oauth1_credentials.inspect}"
			access_token = OAuth::AccessToken.new(consumer, oauth1_credentials['oauth_token'], oauth1_credentials['oauth_token_secret'])

			# Pick some fields
			fields = ['id','first-name', 'last-name','email-address'].join(',')
			# Make a request for JSON data
			xml_str = access_token.get("/v1/people/~:(#{fields})").body

			doc = Nokogiri::XML(xml_str)

			uid =  doc.xpath("//id").first.content
			firstname = doc.xpath("//first-name").first.content
			lastname = doc.xpath("//last-name").first.content
			email = doc.xpath("//email-address").first.content
		rescue
			@user={'status'=>'error'}
			respond_to do |format|
				format.json {render :json=> @user}
			end
			return
		end

		@user = get_auth_user(uid,firstname, lastname,email,oauth1_credentials['oauth_token'],'linkedin')
		respond_to do |format|
			format.json {render :json=> @user}
		end
	end

	def linkedin_callback
		if params["oauth_problem"] == "user_refused"
			respond_to do |format|
				format.html {render 'callback'}
				format.json {render :json=> {'status'=>'error'}}
			end
			return
		else
			begin
				data = request.env["omniauth.auth"]
				uid =  data.uid
				firstname =  data.info.first_name
				lastname =  data.info.last_name
				email =  data.info.email
				access_token =  data.extra.access_token.token
			rescue
				respond_to do |format|
					format.html {render 'callback'}
					format.json {render :json=> {'status'=>'error'}}
				end
				return
			end

			if uid.nil? or firstname.nil? or lastname.nil? or email.nil?
				respond_to do |format|
					format.html {render 'callback'}
					format.json {render :json=> {'status'=>'error'}}
				end
				return
			else
				@user = get_auth_user(uid,firstname, lastname,email,access_token,'linkedin')
				respond_to do |format|
					format.html {render 'callback'}
					format.json {render :json=> @user}
				end
			end
		end

	end

	def get_auth_user(uid,firstname, lastname,email,access_token,provider)
		uauth=UserAuth.where({:uid=>uid,:provider=>provider}).first

		if uauth.nil?
			user=User.find_by_email email
			if user.nil?
				@user=User.create({:firstname=>firstname,:lastname=>lastname,:email=>email})
				@user.confirm!
			else
				@user=user
			end

			UserAuth.create({:uid=>uid,:provider=>provider,:user_id=>@user.id,:token=>access_token})
		else
			@user=uauth.user
		end

		sign_out current_user if current_user

		sign_in @user
		return @user
	end

	def twitter
		# consumer_key and consumer_secret are from Twitter.
		# You'll get them on your application details page.
		consumer_key = '0bV98Yv7mFSDvd1bNc2pFQ'
		consumer_secret = '9h5s4Rhg8zgtD1pf9Hjhqqz07oDCpnFvznmkehAyByY'
		oauth = OAuth::Consumer.new(consumer_key, consumer_secret,{ :site => "https://api.twitter.com" })

		# Ask for a token to make a request
		url = "https://localhost:3000/auth/twitter/callback"
		request_token = oauth.get_request_token(:oauth_callback => url)

		# Take a note of the token and the secret. You'll need these later

		session[:request_token] = request_token.token
		session[:request_token_secret] = request_token.secret

		# Send the user to Twitter to be authenticated
		redirect_to request_token.authorize_url
	end

	def twitter_callback
		consumer_key = '0bV98Yv7mFSDvd1bNc2pFQ'
		consumer_secret = '9h5s4Rhg8zgtD1pf9Hjhqqz07oDCpnFvznmkehAyByY'

		begin
			oauth = OAuth::Consumer.new(consumer_key, consumer_secret,{ :site => "https://api.twitter.com" })


			request_token = OAuth::RequestToken.new(oauth, session[:request_token],session[:request_token_secret])
			access_token = request_token.get_access_token(:oauth_verifier => params[:oauth_verifier])

			response = access_token.request(:get, "/1.1/account/verify_credentials.json")
			user_info = JSON.parse(response.body)

			uid = user_info['id_str']
			fullname = user_info["name"].split(' ')
			first_name, last_name = fullname[0], fullname[1]

			user_detail = {}
			user_detail['uid'] = uid
			user_detail['firstname'] = first_name
			user_detail['lastname'] = last_name


			uauth=UserAuth.where({:uid=>uid,:provider=>'twitter'}).first
		rescue
			@oauth_error = true
			respond_to do |format|
				format.html {render :layout=>false}
			end
			return
		end

		if !uauth.nil?
			@user=uauth.user
			sign_out current_user if current_user
			sign_in @user
		else
			session[:user_info] = user_detail
			@user = nil
		end
		respond_to do |format|
			format.html {render :layout=> false}
		end
	end

	def email_twitter_callback
		email = params['email']
		user_detail = session[:user_info]
		uid = user_detail['uid']
		firstname = user_detail['firstname']
		lastname = user_detail['lastname']

		@user = get_auth_user(uid,firstname, lastname,email,nil,'twitter')

		respond_to do |format|
			format.html {render 'twitter_callback', :layout=>false}
		end

	end

	private
	# Using a private method to encapsulate the permissible parameters is
	# just a good pattern since you'll be able to reuse the same permit
	# list between create and update. Also, you can specialize this method
	# with per-user checking of permissible attributes.
	def user_params
		params.require(:user).permit(:firstname, :lastname, :email, :password, :password_confirmation)
	end

end
