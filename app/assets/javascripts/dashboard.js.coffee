$ ->
  $('#crm_platform').change ->
    platform = $(this).val()
    $('.crm-attributes').hide()
    $('#crm-attributes-' + platform).show()

  $('form#new_invitation')
  	.on('ajax:success', (e, data, status, xhr) ->
  		$('.alert').remove()
  		$('.error-message').remove()
  		$('input#invitation_recipient_email').parent().removeClass('has-error')
  		$('#main').prepend('<div class="alert alert-success fade in">' +
  			'<button class="close" data-dismiss="alert"> ×</button>' +
  			'Invitation sent to email ' + data.recipient_email + '.')
  		$(':input','form#new_invitation')
			  .not(':button, :submit, :reset, :hidden')
			  .val('')
			  .removeAttr('checked')
			  .removeAttr('selected')
		).on 'ajax:error', (e, data, status, xhr) ->
  		$('.alert').remove()
  		$('.error-message').remove()
  		$(this).find('input#invitation_recipient_email').focus()
  		$('input#invitation_recipient_email').parent().addClass('has-error')

  		errors = data.responseJSON
  		errors_html = ''

  		$.each(errors, (index, value) ->
  			errors_html += '<span class="help-block error-message">' + value + '</span>'
  		)

  		$(errors_html).insertAfter('input#invitation_recipient_email')

