module Kemal
  class Form
    abstract class FormField
      # The type of the field.
      @type : String = ""

      # The value of the field's id attribute.
      @id : String

      # The value of the field's name attribute.
      @name : String

      # Additional field attributes.
      @attrs : Hash(String, String)?

      # Is this field required to submit the form.
      @required : Bool

      # The field label.
      @label : Form::Label?

      @validators : Array(Kemal::FormValidator::Validator)

      # The value of the field.
      getter value : String

      getter errors : Array(String) = [] of String

      def initialize(@id, @name, @attrs, @value, @required, @label, @validators)
        if !@attrs.nil?
          reserved_attrs = ["id", "name", "required"]
          reserved_attrs.each { |ra| @attrs.not_nil!.delete(ra) }
        end
      end

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
        io << @label
        io << "<input type=\"#{@type}\" id=\"#{@id}\" name=\"#{@name}\""
        if !@attrs.nil? && !@attrs.not_nil!.empty?
          @attrs.not_nil!.each { |k,v| io << " #{k}=\"#{v}\"" }
        end
        io << " required" if @required
        io << " value=\"#{@value}\""
        io << "/>"
      end
    end

    class EmailField < FormField
      # :inherit:
      @type : String = "email"
    end

    class NumberField < FormField
      # :inherit:
      @type : String = "number"
    end

    class PasswordField < FormField
      # :inherit:
      @type : String = "password"
    end

    class TextField < FormField
      # :inherit:
      @type : String = "text"
    end

    class TextAreaField < FormField
      def to_s(io : IO)
        io << @label
        io << "<textarea"
        if !@attrs.nil? && !@attrs.not_nil!.empty?
          @attrs.not_nil!.each { |k, v| io << " #{k}=\"#{v}\"" }
        end
        io << " required" if @required
        io << ">#{@value}</textarea>"
      end
    end
  end
end