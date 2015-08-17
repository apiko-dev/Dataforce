#this code refactored a bit
#hardcoded preferences moved into settings
ServiceConfiguration.configurations.update {service: "google"}, {$set: Meteor.settings.private.accounts.google}, {upsert: true}
