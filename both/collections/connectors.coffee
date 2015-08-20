@Connectors = new Mongo.Collection('connectors')

deny = -> true

Connectors.deny
  insert: deny
  update: deny
  remove: deny