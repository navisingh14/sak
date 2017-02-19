`import Ember from "ember"`
`import constants from "frontend-upgrade/utils/constants"`

route = Ember.Route.extend
	beforeModel: ->
		@_super.apply this, arguments
		unless @get('session.user')
			@transitionTo('loginmodal')

`export default route`
