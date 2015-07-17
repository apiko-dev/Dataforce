class Series
  constructor: (@chart, data) ->
    @names = []
    @values = []
    @counts = []

    data.forEach (record) =>
      @_updateValue record[@chart.axis.dimensions], record[@chart.axis.metrics]


  _indexOfName: (name) ->
    index = @names.indexOf(name)
    if index < 0
      index = @names.length
      @names.push name
      @values.push(0)
    return index


  _updateValue: (name, value) ->
    index = @_indexOfName(name)
    #value method dispatch
    @["_#{@chart.valueFunction}"](index, value)


  _sum: (index, value) -> @values[index] += value
  _multiply: (index, value) -> @values[index] *= value

  _average: (index, value) ->
    if @counts[index] then @counts[index]++ else @counts[index] = 1
    @values[index] += value

  _valueByIndex: (index) ->
    value = @values[index]
    count = @counts[index]
    value = if count then value / count else value
    Math.round(value * 100) / 100


  convertForHighchart: () -> @names.map (name, index) => {
  name: name,
  data: [@_valueByIndex index]
  }


Template.SalesForceChart.onRendered ->
  @initializeChart = (chart, series) =>
    @$(".sf-chart").highcharts
      chart:
        type: 'column'
      title:
        text: 'Result'
      xAxis:
        categories: [chart.axis.dimensions],
        crosshair: true
      yAxis:
        min: 0,
        title:
          text: '$'
      plotOptions:
        column:
          pointPadding: 0.2,
          borderWidth: 0
      series: series

  @autorun =>
    chart = Session.get 'sfChart'

    console.log chart

    if chart
      Meteor.call 'sfGetTableData', @findParentTemplate('SalesForceSample').getCredentials(), chart.table, chart.filters, (err, tableData) =>
        series = new Series(chart, tableData)
        @initializeChart chart, series.convertForHighchart()