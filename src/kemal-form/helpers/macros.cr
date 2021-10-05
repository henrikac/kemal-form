macro render_form(form, method = "GET", action = "")
  io = IO::Memory.new
  io << "<form method=\"" + {{method.id.stringify}} + "\""
  {% if !action.empty? %}
    io << " method=\"#{action.id.stringify}\""
  {% end %}
  io << ">"
  io << {{ form }}
  io << "</form>"
  io.to_s
end