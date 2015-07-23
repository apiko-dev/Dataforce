//global application's scope
App = {
  DataAdapters: {},
  DataTransformers: {},
  DataMisc: {},
  checkers: {
    MongoId: Match.Where(function (id) {
      check(id, String);
      return /[0-9a-zA-Z]{17}/.test(id);
    })
  },
  temp: {
    //temporal constant instead of user id
    defaultUserId: 'abcdefglkmnoprst'
  }
};
