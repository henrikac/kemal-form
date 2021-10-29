module Kemal
  class Form
    # A text area form field.
    class TextAreaField < Field
      def to_s(io : IO)
        io << "<textarea id=\"#{@id}\" name=\"#{@name}\""
        io << render_attrs if !@attrs.empty?
        io << " required" if @required
        io << ">#{@value}</textarea>"
      end
    end
  end
end
