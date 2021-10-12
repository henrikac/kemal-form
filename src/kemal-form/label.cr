module Kemal
  class Form
    # A HTML form label.
    class Label
      # The id of the element that the label is bound to.
      @for : String

      # The text displayed by the label.
      @text : String

      # Additional label attributes.
      @attrs : Hash(String, String)? = nil

      # Initializes a new form label with the given *for*, *text* and *attrs*.
      def initialize(@for, @text, @attrs)
      end

      def to_s(io : IO)
        io << "<label for=\"#{@for}\""
        if !@attrs.nil?
          @attrs.not_nil!.each { |k,v| io << " #{k}=\"#{v}\"" }
        end
        io << ">#{@text}</label>"
      end
    end
  end
end