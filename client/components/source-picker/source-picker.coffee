Template.SourcePicker.onRendered ->
  analytics.track 'Opened Source Picker'

Template.SourcePicker.onCreated ->
  @showConnectorEntityPicker = new ReactiveVar false
  @entityPickerConnectorName = new ReactiveVar false
  @curveMetadata = {}

  @setEntityPickerVisibility = (visibility) => @showConnectorEntityPicker.set visibility

  @setConnectorEntity = (connectorName, entity) =>
    @setEntityPickerVisibility(false)
    Session.set connectorName, {entity: entity, enabled: true}

  @showEntityPickerFor = (connectorName) =>
    Session.set('searchQuery', '')
    @entityPickerConnectorName.set connectorName
    @setEntityPickerVisibility true

  @clearSearch = -> Session.set('searchQuery', '')
  @clearSearch()

  @autorun =>
    data = Template.currentData()
    axisVar = data.context.axis
    if axisVar and not axisVar.get() then axisVar.set {filterBy: [], orderBy: null}


Template.SourcePicker.helpers
  showConnectorEntityPicker: -> Template.instance().showConnectorEntityPicker.get()
  connectorName: -> Template.instance().entityPickerConnectorName.get()


Template.SourcePicker.events
  'click .cancel-button': (event, tmpl) ->
    tmpl.data.instance.hide()
    tmpl.clearSearch()

  'click .save-button': (event, tmpl) ->
    tmpl.clearSearch()
    tmpl.data.instance.hide()

  'change.radiocheck [name="metricRadio"]': (event, tmpl) ->
    target = tmpl.$(event.target)
    metricsList = target.closest('.metrics-list')

    fieldName = tmpl.$('input:radio[name=metricRadio]:checked').val()

    axis =
      fieldName: fieldName
      connectorId: metricsList.attr('data-connector')
      entityName: metricsList.attr('data-entity')

    curveId = tmpl.get 'newCurveId'
    axisType = tmpl.data.context.axis.get().type

    if not tmpl.curveMetadata.source
      _.extend tmpl.curveMetadata, {
        source: axis.connectorId
        metadata:
          entityName: axis.entityName
      }

    if axisType is 'x'
      _.extend tmpl.curveMetadata.metadata, {
        metric: axis.fieldName
      }
    else
      _.extend tmpl.curveMetadata.metadata, {
        dimension: axis.fieldName
      }

    Curves.update {_id: curveId}, {
      $set:
        source: tmpl.curveMetadata.source
        metadata: tmpl.curveMetadata.metadata
    }
