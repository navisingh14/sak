`import Ember from 'ember'`
`import alertMixin from "frontend-upgrade/mixins/alert_message"`
`import signupMixin from "frontend-upgrade/mixins/sign_up_mixin"`
`import changePasswordMixin from "frontend-upgrade/mixins/change_password"`
`import forgotPasswordMixin from "frontend-upgrade/mixins/forgot_password_mixin"`
`import signinMixin from "frontend-upgrade/mixins/sign_in_mixin"`

controller = Ember.Controller.extend(alertMixin, changePasswordMixin, signupMixin, forgotPasswordMixin, signinMixin,
	reset: ->
		@set 'firstname', undefined
		@set 'lastname', undefined
		@set 'email', undefined
		@set 'password', undefined
		@set 'oldPassword', undefined
		@set 'newPassword', undefined
		@set 'confirmPassword', undefined
		@set 'passwordCnfrm', undefined
		@set 'emailLogin', undefined
		@set 'passwordLogin', undefined
		@set 'hasAcceptedTerms', undefined
		@set 'showAlert', false
		@set 'alertMessage', ''
		@set 'alertType', ''
		@set 'processing', false
	showChngPsswrd: false
	processing: false
)

`export default controller`
