module Kemal
  class Form
    # Super class of all form fields.
    #
    # Custom form fields should inherit from `Kemal::Form::Field`.
    abstract class Field
      # The value of id attribute.
      getter id : String

      # The value of the field's name attribute.
      getter name : String

      # Additional field attributes.
      getter attrs : Hash(String, String)?

      # Set the required attribute.
      getter required : Bool

      # Field validators
      getter validators : Array(Kemal::FormValidator::Validator)

      # The value of the field.
      property value : String

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

      private def render_attrs : String
        str = String.build do |str|
          @attrs.not_nil!.each do |k, v|
            str << " #{k}=\"#{v}\""
          end
        end
        str
      end
    end
  end
end