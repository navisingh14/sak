`import Ember from 'ember'`
`import Resolver from 'ember-resolver'`
`import loadInitializers from 'ember-load-initializers'`
`import config from './config/environment'`

Ember.MODEL_FACTORY_INJECTIONS = true
App = Ember.Application.extend(
  modulePrefix: config.modulePrefix
  podModulePrefix: config.podModulePrefix
  Resolver: Resolver
)
loadInitializers App, config.modulePrefix

$ ->
  $.ajaxPrefilter (options, originalOptions, xhr) ->
    token = $('meta[name="csrf-token"]').attr('content')
    xhr.setRequestHeader('X-CSRF-Token', token)

  $(document).ajaxComplete (event, xhr, settings) ->
    csrf_token = xhr.getResponseHeader('X-CSRF-Token')
    if csrf_token
      $('meta[name="csrf-token"]').attr 'content', csrf_token


`export default App`
