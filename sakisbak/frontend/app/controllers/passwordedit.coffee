`import Ember from 'ember'`
`import alertMixin from "frontend-upgrade/mixins/alert_message"`
`import constants from "frontend-upgrade/utils/constants"`
`import ajax from "frontend-upgrade/helpers/ajax"`

controller = Ember.Controller.extend(alertMixin,
	queryParams: ['reset_password_token']
	reset_password_token: null
	passwd: null
	confirmPasswd: null
	actions:
		resetPasswd: ->
			passwd = @get('passwd')
			c_passwd = @get('confirmPasswd')
			if passwd != c_passwd
				return @showAlertNow('alert-error', 'passwords dont match')
			url = constants.RESET_PASSWORD_URL
			type = 'PATCH'
			hash =
				data:
					reset_password_token: @get('reset_password_token')
					password: passwd
					confirm_password: c_passwd
				success: (responseJSON) ->
					msg = responseJSON.message or 'Password reset.'
					@showAlertNow 'alert-success', msg
					@transitionToRoute('loginmodal')
				error: (jqXhr) ->
					msg = jqXhr.responseJSON.message or 'Could not reset password.'
					@showAlertNow 'alert-error', msg
			unless @get('fastboot.isFastBoot')
				ajax url, type, hash, this
)

`export default controller`
