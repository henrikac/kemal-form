module Kemal
  class Form
    # A select form field.
    #
    # ```
    # class SelectForm < Kemal::Form
    #   field colors : Kemal::Form::SelectField,
    #                  options: [
    #                    Kemal::Form::SelectField::Option.new("blue"),
    #                    Kemal::Form::SelectField::Option.new("green"),
    #                    Kemal::Form::SelectField::Option.new("red"),
    #                    Kemal::Form::SelectField::Option.new("yellow")
    #                  ]
    # end
    # ```
    #
    # will render
    #
    # ```html
    # <select id="colors" name="colors">
    #   <option value="blue">blue</option>
    #   <option value="green">green</option>
    #   <option value="red">red</option>
    #   <option value="yellow">yellow</option>
    # </select>
    # ```
    class SelectField < Field
      # Returns the field's options.
      getter options : Array(Option)

      # Initializes a new `SelectField`.
      def initialize(id,
        name,
        value,
        required,
        label,
        attrs = {} of String => String,
        validators = [] of Kemal::FormValidator::Validator,
        @options = [] of Option)
        super id, name, value, required, label, attrs, validators
      end

      def to_s(io : IO)
        io << "<select id=\"#{@id}\" name=\"#{@name}\""
        io << render_attrs if !@attrs.nil? && !@attrs.not_nil!.empty?
        io << ">"
        @options.each { |opt| io << opt }
        io << "</select>"
      end

      class Option
        # Whether the option is disabled.
        @disabled : Bool

        # The option's label.
        @label : String

        # The option's text.
        @text : String

        # The extra attributes added to the option.
        @attrs : Hash(String, String)?

        # Whether the option is selected.
        property selected : Bool

        # Returns the option's value.
        getter value : String

        def initialize(@value, @text = "", @label = "", @selected = false, @disabled = false, @attrs = nil)
          if !@attrs.nil?
            reserved_attrs = ["disabled", "label", "selected", "value"]
            reserved_attrs.each { |ra| @attrs.not_nil!.delete(ra) }
          end

          @text = @value if @text.empty?
        end

        def to_s(io : IO)
          io << "<option"
          io << " disabled" if @disabled
          io << " selected" if @selected
          io << " label=\"#{@label}\"" if !@label.empty?
          if !@attrs.nil? && !@attrs.not_nil!.empty?
            @attrs.not_nil!.each { |k, v| io << " #{k}=\"#{v}\"" }
          end
          io << " value=\"#{@value}\">#{@text}</option>"
        end
      end
    end
  end
end