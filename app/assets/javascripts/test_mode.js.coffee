$(document).on('ready page:load', ->
  elem = $("#organization_test_mode")
  elem.bootstrapSwitch()

  switchSuccess = ->
    setTimeout( ->
      location.reload()
    , 1000)

  elem.on('switchChange.bootstrapSwitch', ((event, state) ->
    $.ajax(url: elem.data('update-path'), complete: switchSuccess, type: 'POST', data: {"organization[testmode]": ( if state then false else true), _method: 'PATCH' } )
  ));
)