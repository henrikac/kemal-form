require "http"

module Kemal
  class Form
    @ctx : HTTP::Server::Context?

    # Returns the form's fields.
    getter fields : Array(Field)

    # Returns the form's buttons.
    getter buttons : Array(Button)

    # Returns form errors.
    getter errors : Array(String)

    # Initializes a new form.
    #
    # ```
    # class MyForm < Kemal::Form
    # end
    #
    # get "/" do
    #   form = MyForm.new
    #   render "src/views/index.ecr"
    # end
    #
    # post "/" do |env|
    #   form = MyForm.new env
    #   # ...
    #   render "src/views/index.ecr"
    # ```
    def initialize(@ctx = nil)
      @fields = get_form_fields
      @buttons = get_form_buttons
      @errors = [] of String

      radio_groups = Set(String).new
      if @ctx.nil?
        @fields.each do |field|
          if field.is_a?(Kemal::Form::RadioField) && !radio_groups.includes?(field.name)
            field.checked = true
            radio_groups << field.name
          end
        end
      else
        form_body = @ctx.not_nil!.params.body
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

          if field.is_a?(Kemal::Form::SelectField)
            if form_body.has_key?(field.name)
              field.options.each do |option|
                option.selected = option.value == form_body[field.name]
              end
            end
            next
          end

          if form_body.has_key?(field.name)
            field.value = form_body[field.name]
          end
        end
      end
    end

    # Returns `true` if the form is valid, `false` otherwise.
    #
    # ```
    # class MyForm < Kemal::Form
    # end
    #
    # post "/" do |env|
    #   form = MyForm.new env
    #   if form.valid?
    #     puts "form is valid"
    #     env.redirect "/"
    #     next
    #   end
    #   render "src/views/index.ecr"
    # end
    # ```
    def valid? : Bool
      is_valid = true
      @fields.each do |field|
        if field.validate == false
          is_valid = false
        end
      end
      return is_valid
    end

    # Returns the form body.
    #
    # NOTE: This is the same as `env.params.body`.
    def body : URI::Params
      return URI::Params.new if @ctx.nil?

      @ctx.not_nil!.params.body
    end

    # Adds error to the form.
    #
    # ```
    # post "/login" do |env|
    #   form = LoginForm.new env
    #   form.valid?
    #     if wrong_password_entered
    #       form.add_error "Invalid username or password"
    #       ...
    #     end
    #     ...
    #   end
    #   ...
    # end
    # ```
    def add_error(message : String)
      @errors << message
    end

    private def get_form_fields : Array(Field)
      {{ @type.instance_vars.select { |ivar| ivar.type < Field } }}
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
