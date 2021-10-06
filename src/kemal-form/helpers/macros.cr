macro field(decl, **options)
  {%
    field_name = decl.var
    field_type = decl.type
    attrs = options[:attrs]
    required = true
    if options[:required] == false
      required = false
    end
  %}

  @{{field_name}} : {{field_type}} = {{field_type.id}}.new({{field_name.id.stringify}}, {{attrs}}, {{required}})

  def {{field_name.id}} : {{field_type.id}}
    @{{field_name}}
  end
end

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