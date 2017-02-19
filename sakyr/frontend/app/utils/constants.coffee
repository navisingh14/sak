`import config from '../config/environment'`
constants =
  NAMESPACE: "api/v1"
  APP_NAME: ''
  GOOGLE_CLIENT_ID: "766074953374-8tp00okjcdkpvvl4158u0mu739ps7b6l.apps.googleusercontent.com"
  FACEBOOK_APP_ID: '267182603462991'
constants.HOST =  config.APP.HOST + "/" + constants.NAMESPACE
constants.LOGOUT_URL = constants.HOST + '/sign_out'
constants.LOGGED_IN_USER_URL = constants.HOST + '/users/logged_in'
constants.SIGN_IN_URL = constants.HOST + '/users/sign_in'
constants.SIGN_UP_URL = constants.HOST + '/users/sign_up'
constants.FORGOT_PASSWORD_URL = constants.HOST + '/users/forgot_password'
constants.RESET_PASSWORD_URL = constants.HOST + '/auth/password'
constants.CHANGE_PASSWORD_URL = constants.HOST + '/users/change_password'

`export default constants`
