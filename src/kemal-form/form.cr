require "http"

module Kemal
  class Form
    @fields : Array(FormField)

    @buttons : Array(Button)

    def initialize(ctx : HTTP::Server::Context? = nil)
      @fields = get_form_fields
      @buttons = get_form_buttons

      if !ctx.nil?
        form_body = ctx.params.body
        @fields.each do |field|
          if form_body.has_key?(field.name)
            field.value = form_body[field.name]
          end
        end
      end
    end

    def valid?
      is_valid = true
      @fields.each do |field|
        if field.validate == false
          is_valid = false
        end
      end
      return is_valid
    end
    
    def to_s(io : IO)
      @fields.each_with_index do |field, _|
        io << field
      end
      @buttons.each_with_index do |button, _|
        io << button
      end
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