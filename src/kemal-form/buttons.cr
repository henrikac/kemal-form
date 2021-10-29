module Kemal
  class Form
    abstract class Button
      # The button's text
      @text : String

      # The button's type
      @type : String = ""

      # The additional attributes added to the button.
      @attrs : Hash(String, String)

      # Initializes a new button with the given *text* and *attrs*.
      def initialize(@text = "", @attrs = {} of String => String); end

      def to_s(io : IO)
        io << "<button type=\"#{@type}\""
        if !@attrs.empty?
          @attrs.each { |k, v| io << " #{k}=\"#{v}\"" }
        end
        io << ">#{@text}</button>"
      end
    end

    # A HTML button with type *submit*.
    class SubmitButton < Button
      # :inherit:
      @text : String = "Submit"

      # :inherit:
      @type : String = "submit"
    end
  end
end
