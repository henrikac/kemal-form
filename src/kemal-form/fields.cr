module Kemal
  class Form
    # Super class of all form fields.
    #
    # Custom form fields should inherit from `Kemal::Form::FormField`.
    abstract class FormField
      # The type of the field.
      @type : String = ""

      # The value of id attribute.
      @id : String

      # Additional field attributes.
      @attrs : Hash(String, String)?

      # Set the required attribute.
      @required : Bool

      # Field validators
      @validators : Array(Kemal::FormValidator::Validator)

      # The value of the field.
      property value : String

      # The value of the field's name attribute.
      getter name : String

      # The field label.
      getter label : Form::Label?

      # Erros added by field validators.
      getter errors : Array(String) = [] of String

      # Initializes a new form field with the given *id*, *name*, *attrs*, *value*,
      # *required*, *label* and *validators*.
      def initialize(@id, @name, @attrs, @value, @required, @label, @validators)
        if !@attrs.nil?
          reserved_attrs = ["id", "name", "required"]
          reserved_attrs.each { |ra| @attrs.not_nil!.delete(ra) }
        end
      end

      # Validates the field.
      def validate : Bool
        @errors.clear if !@errors.empty?
        @validators.each do |validator|
          begin
            validator.validate(self)
          rescue e : Kemal::Form::ValidationError
            @errors << e.message.not_nil!
          end
        end
        return @errors.empty?
      end

      def to_s(io : IO)
        io << "<input type=\"#{@type}\" id=\"#{@id}\" name=\"#{@name}\""
        io << render_attrs if !@attrs.nil? && !@attrs.not_nil!.empty?
        io << " required" if @required
        io << " value=\"#{@value}\"/>"
      end

      private def render_attrs : String
        str = String.build do |str|
          @attrs.not_nil!.each do |k, v|
            str << " #{k}=\"#{v}\""
          end
        end
        str
      end
    end

    {% begin %}
      {% fields = %w(email number password text) %}
      {% for field in fields %}
        # A form field with type *{{field.id}}*
        class {{field.id.stringify.titleize.id}}Field < FormField
          # :inherit:
          @type : String = {{field.id.stringify}}
        end
      {% end %}
    {% end %}

    # A text area form field.
    class TextAreaField < FormField
      def to_s(io : IO)
        io << "<textarea id=\"#{@id}\" name=\"#{@name}\""
        io << render_attrs if !@attrs.nil? && !@attrs.not_nil!.empty?
        io << " required" if @required
        io << ">#{@value}</textarea>"
      end
    end

    # A form field with type *hidden*.
    class HiddenField < FormField
      def to_s(io : IO)
        io << "<input type=\"hidden\" id=\"#{@id}\" name=\"#{@name}\""
        io << render_attrs if !@attrs.nil? && !@attrs.not_nil!.empty?
        io << " value=\"#{@value}\"/>"
      end
    end
  end
end