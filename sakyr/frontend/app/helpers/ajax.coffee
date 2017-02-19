`import Ember from 'ember'`

# define all library methods here that will be used throughout the application
helper = (url, type, hash, context) ->
  #  writing ajax method so in case we need to put any ajax. This method should be used instead of plain
  #  jquery ajax. This will help keeping the code modular and ajax requests traceable.
  if type.toLowerCase() != 'get' and hash.data != null
    hash.data = JSON.stringify(hash.data)
  hash.url = url
  hash.type = type
  hash.dataType = 'json'
  hash.contentType = 'application/json; charset=utf-8'
  hash.context = context or this
  $.ajax hash

`export default helper`
