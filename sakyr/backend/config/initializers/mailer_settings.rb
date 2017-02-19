# this file configures the mailer according to the environment

# ActionMailer Config
ActionMailer::Base.default :charset => 'utf-8'
ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.default_url_options = { :host => APP_CONFIG.host['url'] }
ActionMailer::Base.smtp_settings = {
		:enable_starttls_auto => APP_CONFIG.mailer['enable_starttls_auto'],
		:address => APP_CONFIG.mailer['address'],
		:port => APP_CONFIG.mailer['port'],
		:authentication => APP_CONFIG.mailer['authentication'],
		:user_name => APP_CONFIG.mailer['username'],
		:password => APP_CONFIG.mailer['password']
}
