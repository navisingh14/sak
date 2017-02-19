Backend::Application.routes.draw do

	# You can have the root of your site routed with "root"
	root 'home#index'
	namespace :api do
		namespace :v1 do
			resources :users, only: %w(index show update create) do
				collection do
					get 'logged_in'
					post 'sign_in' => 'users#user_signin'
					post 'change_password'
					post 'forgot_password'
					get 'resend_confirmation'
					post 'sign_up' => 'users#user_signup'
				end
			end

			post 'users/auth/facebook' => 'users#facebook'
			post 'users/auth/google' => 'users#google'
			post 'users/auth/linkedinLogin' => 'users#linkedin'
			get 'users/auth/twitterLogin' => 'users#twitter'


			#omniauth login
			get "/auth/linkedin/callback" => "users#linkedin_callback"

			get "/auth/twitter/callback" => "users#twitter_callback"
			post "/auth/twitter/email_twitter_callback" => "users#email_twitter_callback"
		end
	end

	devise_for :users, path: 'auth', controllers: {
			confirmations: 'users/confirmations',
			passwords: 'users/passwords',
			registrations: 'users/registrations',
			sessions: 'users/sessions',
	}

	scope :path => "api/v1/" do
		# The priority is based upon order of creation: first created -> highest priority.
		# See how all your routes lay out with "rake routes".

		#For setting routes devise_scope must be used
		devise_scope :user do
			get 'sign_out' => 'users/sessions#destroy'
			get 'sign_in' => 'users/sessions#new'
			get 'sign_up' => 'users/registrations#new'
		end
	end

	# capturing all ember routes below
	get '/home(/*whatever)' => 'home#index'
end
