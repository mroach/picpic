$(document).on 'ready page:load', ->
  handleImageSelected = (event) ->
    $form = $('form')

    $('.progress').show()

    $.ajax
      type: 'POST'
      url: $form.attr('action')
      data: new FormData($form[0])
      cache: false
      contentType: false
      processData: false
      xhr: () ->
        xhr = new window.XMLHttpRequest()
        xhr.upload.addEventListener 'progress', ((progressEvent) ->
          if progressEvent.lengthComputable
            $('.progress').progress
              value: progressEvent.loaded
              total: progressEvent.total
            if progressEvent.loaded == progressEvent.total
              $('.progress .label').text('Processing image...')
        ), false
        xhr
      success: (json) ->
        $('.progress').progress { percent: 100 }
        $('.progress .label').text 'Finished! Reloading...'
        setTimeout (() ->
          window.location.href = $form.attr('action')
        ), 2000

      error: (xhr, status, errorMessage) ->
        $('.progress').hide()
        console.error "Upload failed! #{status}: #{errorMessage}"
        $msg = $('<p/>').attr('class', 'ui error message').text('Upload failed. Sorry.')
        $form.append($msg)

      complete: () ->
        $('input[accept^="image/"]', $form).remove()

  $('input[accept^="image/"]').on 'change', handleImageSelected

  base_input_attrs =
    type: 'file'
    name: 'photo[file]'
    accept: 'image/*'
    style: 'display: none'

  # Handle clicking the 'snap' button
  $('[data-action="snap"]').on 'click', () ->
    input_attrs = base_input_attrs
    input_attrs.capture = true
    $input = $ '<input/>', input_attrs
    $input.on 'change', handleImageSelected
    $('form').append($input)
    $input.trigger('click')

  $('[data-action="pick"]').on 'click', () ->
    $input = $ '<input/>', base_input_attrs
    $input.on 'change', handleImageSelected
    $('form').append($input)
    $input.trigger('click')
