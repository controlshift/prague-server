$ ->
  $("form#new_crm").on "ajax:success", (evt, data) ->
    $("form#new_crm").replaceWith data
    return
  return