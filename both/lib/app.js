//global application's scope
App = {
  DataAdapters: {},
  Connectors: {},
  DataTransformers: {},
  DataMisc: {},
  SalesForce: {
    isNumberType: function (type) {
      return type === 'int' || type === 'double' || type === 'currency' || type === 'percent';
    }
  }
};
