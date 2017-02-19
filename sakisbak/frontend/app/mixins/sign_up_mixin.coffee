`import Ember from "ember"`
`import constants from "frontend-upgrade/utils/constants"`
`import validators from "frontend-upgrade/utils/validators"`
`import ajax from "frontend-upgrade/helpers/ajax"`

mixin = Ember.Mixin.create
  canSignup: true
  canSignupUpdate: (->
    if !Ember.isEmpty(@get('firstname')) and !Ember.isEmpty(@get('lastname')) and !Ember.isEmpty(@get('email')) and !Ember.isEmpty(@get('password')) and !Ember.isEmpty(@get('passwordCnfrm')) and !Ember.isEmpty(@get('hasAcceptedTerms'))
      @set 'canSignup', true
    else
      @set 'canSignup', false
      @set 'alertMessage', 'Please provide all details to sign up.'
      return
    if !@get('isEmailValid')
      @set 'canSignup', false
      return
    if @get('password')
      if @get('password').toString().length < 8
        @set 'canSignup', false
        @set 'alertMessage', 'Password should be atleast 8 characters.'
        return
    if @get('password') != @get('passwordCnfrm')
      @set 'canSignup', false
      @set 'alertMessage', 'Password and Confirmation password do not match.'
      return
    if !@get('hasAcceptedTerms')
      @set 'canSignup', false
      @set 'alertMessage', 'You have to agree to the terms and conditions in order to sign up.'
    return
  ).observes('firstname', 'lastname', 'password', 'passwordCnfrm', 'isEmailValid', 'hasAcceptedTerms')
  isEmailValid: (->
    validators.isEmailValid @get('email')
  ).property('email')
  actions: signup: ->
    self = this
    if @get('canSignup') && !@get('fastboot.isFastBoot')
      $('#signup-submit').attr 'disabled', 'disabled'
      user = {}
      user.firstname = self.get('firstname')
      user.lastname = self.get('lastname')
      user.email = self.get('email')
      user.password = self.get('password')
      data = user: user
      type =  'POST'
      url = constants.SIGN_UP_URL
      dataType =  'json'
      data =  data
      hash =
        dataType: dataType
        data: data
      request = ajax(url, type, hash, @)
      request.done (response) ->
        if response.msg == 1
          self.showAlertNow 'alert-success', 'User has been created please confirm your account from the email you provided'
          self.getLoggedInAndSignIn()
        else
          if response.email
            errorMessage = 'Sorry this email ' + response.email[0] + '. Please sign up with a different email.'
            self.showAlertNow 'alert-error', errorMessage
          $('#signup-submit').removeAttr 'disabled'
      request.fail (jqXHR, textStatus, e) ->
        console.log 'Error Occurred' + e
    else
      if Ember.isEmpty(@get('canSignup'))
        self.showAlertNow 'alert-error', 'Please provide all the details to sign up.'
        return
      self.showAlertNow 'alert-error', @get('alertMessage')


`export default mixin`
