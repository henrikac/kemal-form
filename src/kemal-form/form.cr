require "http"

module Kemal
  class Form
    # Fields added to the form.
    getter fields : Array(FormField)

    # Buttons added to the form.
    getter buttons : Array(Button)

    # Initializes a new form.
    def initialize(ctx : HTTP::Server::Context? = nil)
      @fields = get_form_fields
      @buttons = get_form_buttons

      radio_groups = Set(String).new
      if ctx.nil?
        @fields.each do |field|
          if field.is_a?(Kemal::Form::RadioField) && !radio_groups.includes?(field.name)
            field.checked = true
            radio_groups << field.name
          end
        end
      else
        form_body = ctx.params.body
        @fields.each do |field|
          if field.is_a?(Kemal::Form::CheckboxField)
            field.checked = form_body.has_key?(field.name)
            next
          end

          if field.is_a?(Kemal::Form::RadioField)
            if form_body.has_key?(field.name)
              field.checked = field.value == form_body[field.name]
            elsif !radio_groups.includes?(field.name)
              field.checked = true
              radio_groups << field.name
            end
            next
          end

          if form_body.has_key?(field.name)
            field.value = form_body[field.name]
          end
        end
      end
    end

    # Validates the form.
    def valid?
      is_valid = true
      @fields.each do |field|
        if field.validate == false
          is_valid = false
        end
      end
      return is_valid
    end

    private def get_form_fields : Array(FormField)
      {{ @type.instance_vars.select { |ivar| ivar.type < FormField } }}
    end

    private def get_form_buttons : Array(Button)
      buttons = [] of Button
      {% begin %}
        {% form_buttons = @type.instance_vars.select { |ivar| ivar.type < Button } %}
        {% if form_buttons.empty? %}
          return buttons
        {% else %}
          return buttons + {{form_buttons}}
        {% end %}
      {% end %}
    end
  end
end