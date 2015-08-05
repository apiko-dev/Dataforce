if not ServiceConfiguration.configurations.findOne(service: "google")
#todo: @vlad it should be removed or moved into settings
  ServiceConfiguration.configurations.insert
    service: 'google'
    clientId: '492445934834-bi454uh910tkg89rogdk1nvmmd48t202.apps.googleusercontent.com'
    secret: 'EhX0wNysnD9xUrYaq_ZdtBI7'
    loginStyle: 'popup'