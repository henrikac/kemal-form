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

      def initialize(field_name : String, @attrs, @required, @label)
        @id = field_name
        @name = field_name
        if !@attrs.nil?
          a = @attrs.not_nil!
          a.delete("required")
          if a.has_key?("id") && !a["id"].empty?
            @id = a.delete("id").not_nil!
          end
          if a.has_key?("name") && !a["name"].empty?
            @name = a.delete("name").not_nil!
          end
        end
      end

      def to_s(io : IO)
        io << @label
        io << "<input type=\"#{@type}\" id=\"#{@id}\" name=\"#{@name}\""
        if !@attrs.nil? && !@attrs.not_nil!.empty?
          @attrs.not_nil!.each { |k,v| io << " #{k}=\"#{v}\"" }
        end
        io << " required" if @required
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
        io << "></textarea>"
      end
    end
  end
end