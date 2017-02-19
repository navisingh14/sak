`import DS from "ember-data"`

model = DS.Model.extend
  email: DS.attr('string')
  firstname: DS.attr('string')
  lastname: DS.attr('string')

`export default model`
