initialize = (application) ->
	application.inject 'route', 'fastboot', 'service:fastboot'
	application.inject 'controller', 'fastboot', 'service:fastboot'
	application.inject 'component', 'fastboot', 'service:fastboot'
	return

fastboot = {
	name: 'fastboot',
	initialize: initialize
};

`export default fastboot`
