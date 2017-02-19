`import Ember from "ember"`
`import constants from "frontend-upgrade/utils/constants"`
`import validators from "frontend-upgrade/utils/validators"`
`import ajax from "frontend-upgrade/helpers/ajax"`

mixin = Ember.Mixin.create
	canLogin: false
	showAlertNow: (type, msg) ->
		alert msg
	facebookLoginSuccess: (data) ->
		if data.status != 'error'
			@getLoggedInAndSignIn()
		else
			return @showAlertNow('alert-error', 'Login with facebook failed. Please try manual login.')
		return
	canLoginUpdate: (->
		if !Ember.isEmpty(@get('emailLogin')) and !Ember.isEmpty(@get('passwordLogin'))
			@set 'canLogin', true
		if !@get('isLoginEmailValid')
			@set 'canLogin', false
		if @get('passwordLogin')
			if @get('passwordLogin').toString().length < 8
				return @set('canLogin', false)
		return
	).observes('isLoginEmailValid', 'passwordLogin')
	isLoginEmailValid: (->
		validators.isEmailValid @get('emailLogin')
	).property('emailLogin')
	getLoggedInAndSignIn: ->
		self = this
		type = 'GET'
		xhrFields =
			withCredentails: true
		url =  constants.LOGGED_IN_USER_URL
		success = (data) ->
			if data['message'] != 'Nobody logged In'
				self.store.pushPayload data
				self.store.find('user', data.user.id).then (user) ->
					self.get('session').set 'user', user
					self.transitionToRoute 'home'
		hash =
			xhrFields: xhrFields
			success: success
		unless @get('fastboot.isFastBoot')
			ajax(url, type, hash, @)

	googleLogin: (googleUser)->
		@send('googlelogin', googleUser)

	googleLoginOnSuccess: (data) ->
		self = this
		if data.status != 'error'
			this.store.pushPayload data
			this.store.find('user', data.user.id).then (user) ->
				self.get('session').set 'user', user
				self.transitionToRoute('home')
		else
			return @showAlertNow('alert-error', 'Login with google failed. Please try manual login.')
		return

	actions:
		login: ->
			self = this
			if @get('canLogin')
				credentials = {}
				user = {}
				user.email = self.get('emailLogin')
				user.password = self.get('passwordLogin')
				credentials.user = user
				hash =
					data: credentials
					success: (response) ->
						if response.message == 'Sign in successful'
							self.getLoggedInAndSignIn()
						else
							self.showAlertNow 'alert-error', response.message
				unless @get('fastboot.isFastBoot')
					ajax( constants.SIGN_IN_URL, 'POST',hash, @)
			else
				self.showAlertNow '', 'It seems you have missed some fields.Please make sure all the above fields are filled and correct.'

		facebooklogin: ->
			if window.fbLoaded
				self = this
				FB.init
					appId: constants.FACEBOOK_APP_ID
					status: true
					cookie: true
					xfbml: true
				return FB.login(((response) ->
					if response.status == 'connected' && !self.get('fastboot.isFastBoot')
						hash =
							data:
								access_token: response.authResponse.accessToken
							success: self.facebookLoginSuccess
						return ajax( constants.HOST + '/users/auth/facebook', 'post', hash, self)
					return
				), scope: 'email')
			return
		googlelogin: (googleUser)->
			self = this
			hash =
				data:
					access_token: googleUser.getAuthResponse().access_token
				success: (response)->
					self.googleLoginOnSuccess(response)
			unless @get('fastboot.isFastBoot')
				gapi.auth2.getAuthInstance().signOut().then(->
					console.log("Logged out successfully")
				)
				ajax(constants.HOST + '/users/auth/google','post',hash, @)

`export default mixin`
