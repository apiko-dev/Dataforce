Template.Home.onRendered ->
  console.log 'rendered'
  @$("select").select2({dropdownCssClass: 'dropdown-inverse'})


Template.Home.events
  'click .btn-group.fix-dropdown': (e, tmpl) ->
#    $(event.target).parent('.btn-group.fix-dropdown').toggleClass('open')