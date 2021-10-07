macro field(decl, **options)
  {%
    field_name = decl.var
    field_type = decl.type
    attrs = options[:attrs]

    required = true
    if options[:required] == false
      required = false
    end

    label = options[:label]
    if label.nil?
      label_for = field_name.id.stringify
      label_text = field_name.id.stringify.titleize
      if !attrs.nil? && attrs.keys.includes?("id")
        label_for = attrs["id"]
        label_text = attrs["id"].titleize
      end
    end
  %}

  @{{field_name}} : {{field_type}} = {{field_type.id}}.new(
    {{field_name.id.stringify}},
    {{attrs}},
    {{required}},
    {% if label.nil? %}
      Kemal::Form::Label.new({{label_for}}, {{label_text}}, nil))
    {% else %}
      {{label}})
    {% end %}

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