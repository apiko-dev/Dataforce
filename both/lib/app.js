//global application's scope
App = {
  DataAdapters: {},
  Connectors: {},
  DataTransformers: {},
  DataMisc: {},
  Functions: {},
  SalesForce: {
    isNumberType: function (type) {
      return type === 'int' || type === 'double' || type === 'currency' || type === 'percent';
    }
  },
  isAdmin: function (userId) {
    userId = userId || Meteor.userId();
    return Roles.userIsInRole(userId, ['admin']);
  }
};

ConnectorNames = {
  GoogleAnalytics: 'Google Analytics',
  Salesforce: 'Salesforce',
  Dataforce: 'Dataforce', //used for curve references
  Zendesk: 'Zendesk'
};
