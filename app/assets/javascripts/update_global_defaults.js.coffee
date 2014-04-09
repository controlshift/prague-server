$ ->
  $(".global_defaults_form").on "ajax:success", (evt, data) ->
    $(".global_defaults_form").replaceWith data
    return
  return