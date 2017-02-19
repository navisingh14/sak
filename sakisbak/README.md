Setup Instructions:

frontend:
- npm install
- change host in constant.coffee in app folder
- brunch w -s				#to run brunch server
- brunch w -e rails_dev		#to build in rails development environment
- brunch w -e rails_prod	#to build in rails production environment
- brunch w -e mobile		#to build for mobile
- brunch w -e test			#to build for karma test

backend:
- bundle install
- change username and password of your postgres user in /backend/config/database.yml
- rake db:drop
- rake db:create
- rake db:migrate
- thin start --ssl

Run tests:
Frontend tests:
- cd frontend
- brunch w -e test		#to build for test
- karma start

Backend unit(rspec) tests:
- cd backend
- bundle exec rspec spec/

Backend integration(cucumber) tests:
- cd backend
- bundle exec cucumber

To deploy on a fresh machine enter following commands in order.
	cap local prepare_env
	cap local deploy
	cap local db:setup_dbms
	cap local tasks:db_setup
	cap local tasks:thin_start
	
