Meteor.publish 'salesforceTables', () -> SalesforceTables.find {}, {fields: {fields: 0}}


Meteor.publish 'salesforceTableFields', (tableName) ->
  check tableName, String
  SalesforceTables.find {name: tableName}


Meteor.startup ->
#upload default descriptions from /sf/tables.json file
  if SalesforceTables.find().count() is 0
    tables = JSON.parse Assets.getText('sf/tables.json')
    tables.forEach (table) -> SalesforceTables.insert table


#Next method used to export current salesforce tables into file in private folder
#this file called /sf/tables.json and used as default configuration when
# app starts first time. can be called only in development mode
_.extend App.SalesForce, {
  exportTablesDescriptions: () ->
    fs = Npm.require('fs');
    privatePath = fs.realpathSync('./../../../../../private/sf');
    if fs.existsSync(privatePath)
      filePath = "#{privatePath}/tables.json"
      fs.writeFile filePath, JSON.stringify SalesforceTables.find().fetch()
    else
      console.log(privatePath, ' doesn\'t exist');
}
