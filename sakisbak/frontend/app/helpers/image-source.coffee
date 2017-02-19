`import Ember from 'ember'`

# This function receives the params `params, hash`
imageSource = (params) ->
  unless params[0].get('fastboot.isFastBoot')
    if navigator.app == "mobile"
      params[1]
    else
      "/" + params[1]

  return params[0]

ImageSourceHelper = Ember.Helper.helper imageSource

`export { imageSource }`

`export default ImageSourceHelper`
