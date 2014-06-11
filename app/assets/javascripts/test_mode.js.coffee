$(document).on('ready page:load', ->
  elem = $("#organization_test_mode")
  elem.bootstrapSwitch()
  switchSuccess = ->
    location.reload()
  elem.on('switchChange.bootstrapSwitch', ((event, state) ->
    $.ajax(url: elem.data('update-path'), success: switchSuccess, type: 'POST', data: {"organization[testmode]": state, _method: 'PATCH' } )
    location.reload()
  ));
)