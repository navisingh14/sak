`import Ember from "ember"`

animatedView = (self, time) ->
  self.$().css 'opacity', 0
  if time
    self.$().animate { opacity: 1 }, time
  else
    self.$().animate { opacity: 1 }, 1000

view = Ember.Component.extend(
  templateName: 'signup'
  didInsertElement: ->
    animatedView this
  signupButtonClass: (->
    'ch-btn signupbutton floatLT'
  ).property('controller.canSignup')
  setFocus: (->
    if @get('controller').get('hasAcceptedTerms')
      return $('.checkbox-signup').focus()
    return
  ).observes('controller.hasAcceptedTerms'))

`export default view`
