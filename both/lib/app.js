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
  }
};

ConnectorNames = {
  GoogleAnalytics: 'Google Analytics',
  Salesforce: 'Salesforce',
  Zendesk: 'Zendesk'
};
