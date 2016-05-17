$(document).on 'ready page:load', ->
  $('.message .close')
    .on 'click', () ->
      $(this).closest('.message').transition('fade')
