//= require jquery
$ ->
  $('#crm_platform').change ->
    platform = $(this).val()
    $('.crm-specific-fields').hide()
    $('#crm-specific-fields-' + platform).show()
