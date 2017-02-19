`import Ember from "ember"`
`import constants from "frontend-upgrade/utils/constants"`

view = Ember.Component.extend
  templateName: 'components/login'


  onFailure: (error)->
    console.log(error)

  didInsertElement: ->
    self = this
    gapi.signin2.render('my-signin2',
      'scope': 'profile email'
      'width': 240
      'height': 50
      'longtitle': true
      'theme': 'dark'
      'onsuccess': @ctrl.googleLogin.bind(@ctrl)
      'onfailure': @onFailure.bind(@ctrl)
    )

`export default view`
