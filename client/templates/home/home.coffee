Template.Home.onRendered ->
  @$("select").select2({dropdownCssClass: 'dropdown-inverse'})
  $("select").select2()
  $("input").radiocheck()
