SimpleForm.setup do |config|
  config.wrappers :vertical_form, class: :field, hint_class: :field_with_hint, error_class: :error do |b|
    b.use :html5
    b.use :placeholder
    b.optional :maxlength
    b.optional :pattern
    b.optional :min_max
    b.optional :readonly
    b.use :label_input
    b.use :error, wrap_with: { tag: :small, class: :error }
    b.use :hint,  wrap_with: { tag: :span, class: :hint }
  end

  config.wrappers :horizontal_form, tag: 'div', class: 'field inline', hint_class: :field_with_hint, error_class: :error do |b|
    b.use :html5
    b.use :placeholder
    b.optional :maxlength
    b.optional :pattern
    b.optional :min_max
    b.optional :readonly
    b.use :label_input
  end

  # CSS class for buttons
  config.button_class = 'ui primary button'

  # Set this to div to make the checkbox and radio properly work
  # otherwise simple_form adds a label tag instead of a div arround
  # the nested label
  config.item_wrapper_tag = :div

  # CSS class to add for error notification helper.
  config.error_notification_class = 'ui red inverted attached segment'

  # The default wrapper to be used by the FormBuilder.
  config.default_wrapper = :vertical_form

  config.default_form_class = 'ui form'
end
