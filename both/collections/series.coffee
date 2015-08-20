@Series = new Meteor.Collection 'series'


deny = -> true

Series.deny
  insert: deny
  update: deny
  remove: deny