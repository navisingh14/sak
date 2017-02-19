`import Ember from 'ember'`
`import config from './config/environment'`

Router = Ember.Router.extend(location: config.locationType)
Router.map ->
	@route 'passwordedit', path: '/auth/password/edit'
	@route 'loginmodal', path: '/'
	@route 'home', resetNamespace: true

`export default Router`
