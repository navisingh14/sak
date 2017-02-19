Rails.application.config.middleware.use OmniAuth::Builder do
	provider :linkedin, '75291j3don9dv6', 'GwSLgQ7U08Z2yg1T',
					 :scope => "r_basicprofile r_emailaddress",
					 :field => ["id", "first-name", "last-name", "email-address", "headline", "picture-url", "public-profile-url"]
end