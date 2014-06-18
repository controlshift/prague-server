$(document).on('ready page:load', ->
  elem = $("#organization_test_mode")
  elem.bootstrapSwitch()
  reload = ->
    location.reload
  switchSuccess = ->
    setTimeout(reload, 1000)
  elem.on('switchChange.bootstrapSwitch', ((event, state) ->
    $.ajax(url: elem.data('update-path'), complete: switchSuccess, type: 'POST', data: {"organization[testmode]": state, _method: 'PATCH' } )
  ));
)