initialize = (application) ->
  application.inject 'route', 'session', 'service:session'
  application.inject 'controller', 'session', 'service:session'
  application.inject 'component', 'session', 'service:session'
  return

session = {
  name: 'session',
  initialize: initialize
};

`export default session`
