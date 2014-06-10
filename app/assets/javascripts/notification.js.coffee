$(document).on('ready page:load', ->
  appendAndShowNotification = (notification) ->
    notification.css 'display', 'none'
    $('.container-fluid').append notification
    notification.css 'position', 'absolute'
    notification.css('top', Math.max(0, (($(window).height() - $(notification).outerHeight()) / 2) + $(window).scrollTop()) + 'px');
    notification.css('left', Math.max(0, (($(window).width() - $(notification).outerWidth()) / 2) + $(window).scrollLeft()) + 'px');
    notification.css 'display', 'block'
    notification.fadeOut(9000)

  $(document).ajaxSuccess ->
    notification = $("<div class='alert alert-success alert-dismissable'>").html """<button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
      Your settings have been updated."""
    appendAndShowNotification notification

  $(document).ajaxError ->
    notification = $("<div class='alert alert-success alert-danger'>").html """<button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
      Something has gone wrong. Try again."""
    appendAndShowNotification notification
)