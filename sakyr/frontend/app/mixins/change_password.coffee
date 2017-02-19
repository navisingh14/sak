`import Ember from "ember"`
`import constants from "frontend-upgrade/utils/constants"`
`import ajax from "frontend-upgrade/helpers/ajax"`

mixin = Ember.Mixin.create
  destroySession: ->
    @get('session').set 'user', null
    location.reload()
  changePasswordMessage: (response) ->
    alertMessageType = ''
    if response == 'Password change successful. Please login again with new password.'
      alertMessageType = 'alert-success'
    if response == 'There was some error on our side. Please try again later.' or response == 'It seems you entered the wrong old password'
      alertMessageType = 'alert-error'
    @showAlertNow alertMessageType, response
    if Ember.isEqual(@get('alertType'), 'alert-success')
      return Ember.run.debounce(this, @destroySession, 1000)
    return
  validateChangePassword: ->
    if Ember.isEmpty(@get('oldPassword')) or Ember.isEmpty(@get('confirmPassword')) or Ember.isEmpty(@get('newPassword'))
      @changePasswordMessage 'It seems you have left some fields empty.'
      return false
    if @get('newPassword.length') < 8
      @changePasswordMessage 'Password length should be greater than or equal to 8'
      return false
    if @get('newPassword') == @get('oldPassword')
      if !confirm('You have entered same new password and Old Password.Are you sure?')
        @changePasswordMessage 'You have entered same new password and Old Password.'
        return false
      else
        return true
    if @get('newPassword') != @get('confirmPassword')
      @changePasswordMessage 'New password and confirm password dont match'
      return false
    true
  actions: changePassword: ->
    if !@validateChangePassword()
      return
    self = this
    url = constants.CHANGE_PASSWORD_URL
    type = 'POST'
    hash =
      data: 'user':
        'id': self.get('session.user.id')
        'oldPassword': self.get('oldPassword')
        'newPassword': self.get('newPassword')
      success: (response) ->
        self.set 'notice', response.message
        self.changePasswordMessage response.message
      error: (response) ->
        self.changePasswordMessage response.responseJSON.message
    unless @get('fastboot.isFastBoot')
      ajax url, type, hash


`export default mixin`
