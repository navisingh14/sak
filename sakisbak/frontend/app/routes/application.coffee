`import Ember from "ember"`
`import constants from "frontend-upgrade/utils/constants"`
`import ajax from "frontend-upgrade/helpers/ajax"`

route = Ember.Route.extend
	fastboot: Ember.inject.service()

	beforeModel: ->
		return Ember.RSVP.Promise.all([@getCurrentUser()])

	getCurrentUser:()->
		that = @
		that = this
		hash =
			success: (data)->
				if data['message'] != 'Nobody logged In'
					that.store.pushPayload(data)
					that.store.find('user',data.user.id).then((user)->
						that.get('session').set('user',user)
					)
		unless @get('fastboot.isFastBoot')
			ajax(constants.LOGGED_IN_USER_URL,'GET',hash,@)

	actions:
		changePasswd: ->
			@send 'openModal', 'change-password', @controllerFor('loginmodal')
		logout: ->
			that = this
			hash =
				success: ->
					that.set 'session.user', undefined
					that.transitionTo('loginmodal')
					Ember.run.later ->
						window.location.reload()
					, 500
			ajax(constants.LOGOUT_URL, 'GET', hash, @ )


		openModal: (template, ctrl) ->
			lastRenderedTemplate = @lastRenderedTemplate
			@render 'components/modal',
				outlet: 'modal'
				into: 'application'
				controller: ctrl
			if template
				@render template,
					into: 'components/modal'
					controller: ctrl
			@controllerFor('application').set 'modalShown', true
			@lastRenderedTemplate = lastRenderedTemplate
		closeModal: ->
			@controllerFor('application').set 'modalShown', false
			@disconnectOutlet
				outlet: 'modal'
				parentView: 'application'

`export default route`
