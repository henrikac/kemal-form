module Kemal
  class Form
    # Super class of all form fields.
    #
    # Custom form fields should inherit from `Kemal::Form::Field`.
    abstract class Field
      # Returns the value of the field's id attribute.
      getter id : String

      # Returns the value of the field's name attribute.
      getter name : String

      # Returns the additional attributes added to the field.
      getter attrs : Hash(String, String)?

      # Returns whether the field's required attribute should be set.
      getter required : Bool

      # Returns the field's validators.
      getter validators : Array(Kemal::FormValidator::Validator)

      # Returns the value of the field.
      property value : String

      # Returns the field's label.
      getter label : Form::Label?

      # Returns the field errors added by the field validators.
      getter errors : Array(String) = [] of String

      # Initializes a new form field with the given *id*, *name*, *attrs*, *value*,
      # *required*, *label* and *validators*.
      def initialize(@id,
        @name,
        @attrs,
        @value,
        @required,
        @label = nil,
        @validators = [] of Kemal::FormValidator::Validator)
        if !@attrs.nil?
          reserved_attrs = ["id", "name", "required"]
          reserved_attrs.each { |ra| @attrs.not_nil!.delete(ra) }
        end

        if @label.nil?
          @label = Kemal::Form::Label.new(@id, @id.titleize, nil)
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
        String.build do |str|
          @attrs.not_nil!.each do |k, v|
            str << " #{k}=\"#{v}\""
          end
        end
      end
    end
  end
end