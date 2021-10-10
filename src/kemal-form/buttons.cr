module Kemal
  class Form
    abstract class Button
      @text : String
      @type : String = ""
      @attrs : Hash(String, String)

      def initialize(@text = "", @attrs = {} of String => String); end

      def to_s(io : IO)
        io << "<button type=\"#{@type}\""
        if !@attrs.empty?
          @attrs.each { |k, v| io << " #{k}=\"#{v}\"" }
        end
        io << ">#{@text}</button>"
      end
    end

    class SubmitButton < Button
      @text : String = "Submit"
      @type : String = "submit"
    end
  end
end