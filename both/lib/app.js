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
  checkAdmin: function () {
    console.log('check admin ', Meteor.user().role);
    console.log(Meteor.user().role === 'admin');
    return Meteor.user().role === 'admin';
  }
};

ConnectorNames = {
  GoogleAnalytics: 'Google Analytics',
  Salesforce: 'Salesforce',
  Zendesk: 'Zendesk'
};
