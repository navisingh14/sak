`import Ember from "ember"`

mixin = Ember.Mixin.create
  showAlert: false
  alertType: ''
  alertMessage: ''
  showAlertObs: (->
    $('#alertBox').attr 'class', 'alert'
    self = this
    alertClass = self.get('alertType')
    self.set 'alertType', ''
    if @get('showAlert') != null
      return Ember.run.next(->
        $('#alertBox').addClass alertClass
        $('#alertBox').css 'opacity', 0
        $('#alertBox').animate { opacity: 1 }, 250
      )
    return
  ).observes('showAlert', 'alertMessage')
  showAlertNow: (alertType, alertMessage) ->
    @set 'alertType', alertType
    @set 'showAlert', true
    @set 'alertMessage', alertMessage
  hideAlert: ->
    self = this
    $('#alertBox').css 'opacity', 1
    $('#alertBox').animate { opacity: 0 }, 250, ->
      self.set 'showAlert', false

`export default mixin`
