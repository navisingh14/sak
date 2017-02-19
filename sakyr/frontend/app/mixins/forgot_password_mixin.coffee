`import Ember from "ember"`
`import constants from "frontend-upgrade/utils/constants"`
`import validators from "frontend-upgrade/utils/validators"`
`import ajax from "frontend-upgrade/helpers/ajax"`

mixin = Ember.Mixin.create
	actions:
		forgotpassword: ->
			self = this
			unless @get('fastboot.isFastBoot')
				$('#forgot-password-btn').attr 'disabled', 'disabled'
			if self.get('emailLogin') and validators.isEmailValid(self.get('emailLogin'))
				data = {}
				data.email = self.get('emailLogin')
				self.set 'processing', true
				type =  'POST'
				url = constants.FORGOT_PASSWORD_URL
				data = data
				success =  (response) ->
					alertTypeMessage = ''
					self.set 'processing', false
					unless @get('fastboot.isFastBoot')
						$('#forgot-password-btn').removeAttr 'disabled'
					if response.message == 'User does not exist.'
						alertTypeMessage = 'alert-error'
					else
						alertTypeMessage = 'alert-success'
					self.showAlertNow alertTypeMessage, response.message
				error =  ->
					self.set 'processing', false
					unless @get('fastboot.isFastBoot')
						$('#forgot-password-btn').removeAttr 'disabled'
				hash =
					data: data
					success: success
					error: error
				unless @get('fastboot.isFastBoot')
					ajax(url, type, hash, @)
			else
				self.showAlertNow 'alert-error', 'Please make sure you provide the correct email address'
				unless @get('fastboot.isFastBoot')
					$('#forgot-password-btn').removeAttr 'disabled'

`export default mixin`
