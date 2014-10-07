//= require jquery
$ ->
  $('#crm_platform').change ->
    platform = $(this).val()
    $('.crm-attributes').hide()
    $('#crm-attributes-' + platform).show()
