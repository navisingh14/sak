#####################################################################
# Copyright (C) 2013 Navyug Infosolutions Pvt Ltd.
# Developer : Ranu Pratap Singh
# Email : ranu.singh@navyuginfo.com
# Created Date : 25/7/14
#####################################################################


module Users
	class PasswordsController < Devise::PasswordsController
		def edit
			render 'home/index'
		end

		# PUT /resource/password
		def update
			@user = User.reset_password_by_token(reset_params(params))
			if @user.errors.empty?
				user.unlock_access! if unlockable?(@user)
				render :json => {message: 'Password set successfully. You may now login with new password.'}, :statue => :ok
			else
				error_message = 'could not reset the password'
				if !@user.errors[:reset_password_token].empty?
					error_message = 'The Password Reset Token is Invalid'
				elsif !@user.errors.messages[:password].empty?
					error_message = 'The Password Invalid. Min 8 characters required.'
				end
				render :json => {message: error_message}, :status => :unauthorized
			end
		end

		private
		def reset_params(params)
			params.slice :reset_password_token, :password, :confirm_password
		end

	end
end