`import Ember from "ember"`

validators = {}

validators.isEmailValid = (email) ->
  emailRegEx = undefined
  emailRegEx = new RegExp(/^((?!\.)[a-z0-9._%+-]+(?!\.)\w)@[a-z0-9-]+\.[a-z.]{1,5}(?!\.)\w$/i)
  emailRegEx.test email

`export default validators`
