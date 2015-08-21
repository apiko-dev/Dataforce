@SalesforceTables = new Mongo.Collection('salesforce_tables')

SalesforceTables.allow
  insert: App.isAdmin
  update: App.isAdmin
  remove: App.isAdmin