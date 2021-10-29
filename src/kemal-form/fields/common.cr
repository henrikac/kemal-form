module Kemal
  class Form
    {% begin %}
      {% fields = %w(checkbox email hidden number password radio text) %}
      {% for field in fields %}
        # A form field with type *{{field.id}}*
        class {{field.id.stringify.titleize.id}}Field < Field
          # The type of the field.
          @type : String = {{field.id.stringify}}
          
          {% if field.id.stringify == "checkbox" || field.id.stringify == "radio" %}
            # Whether the field is checked.
            property checked : Bool = false

            def to_s(io : IO)
              io << "<input type=\"{{field.id}}\" id=\"#{@id}\" name=\"#{@name}\""
              io << render_attrs if !@attrs.empty?
              io << " value=\"#{@value}\""
              io << " checked" if @checked
              io << " required" if @required
              io << "/>"
            end
          {% else %}
            def to_s(io : IO)
              io << "<input type=\"#{@type}\" id=\"#{@id}\" name=\"#{@name}\""
              io << render_attrs if !@attrs.empty?
              io << " value=\"#{@value}\""
              io << " required" if @required
              io << "/>"
            end
          {% end %}
        end
      {% end %}
    {% end %}
  end
end
