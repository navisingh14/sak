class ApplicationController < ActionController::Base
	# Prevent CSRF attacks by raising an exception.
	# For APIs, you may want to use :null_session instead.
	protect_from_forgery with: :exception
	skip_before_action :verify_authenticity_token
	after_action :set_csrf_token

	protected
		def set_csrf_token
			if request.xhr?
				# Add the newly created csrf token to the page headers
				# These values are sent on 1 request only response.
				headers['X-CSRF-Token'] = "#{form_authenticity_token}"
			end
		end
end
