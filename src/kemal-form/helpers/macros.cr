macro button(decl, **options)
  {%
    button_name = decl.var
    button_type = decl.type

    button_text = options[:text]
    button_args = options[:args]
  %}

  @{{button_name}} : {{button_type}} = {{button_type.id}}.new(
    {% if !button_text.nil? %}
      text: {{button_text}}{% unless button_args.nil? %},{% end %}
    {% end %}
    {% if !button_args.nil? %}
      args: {{button_args}}
    {% end %}
    )

  def {{button_name.id}} : {{button_type.id}}
    @{{button_name}}
  end
end

macro field(decl, **options)
  {%
    field_name = decl.var
    field_type = decl.type

    id_attr = options[:id]
    if id_attr.nil?
      id_attr = field_name.id.stringify
    end

    name_attr = options[:name]
    if name_attr.nil?
      name_attr = field_name.id.stringify
    end

    extra_attrs = options[:attrs]

    field_value = options[:value]
    if field_value.nil?
      field_value = ""
    end

    required = false
    if options[:required] == true
      required = true
    end

    label = options[:label]
    if label.nil?
      label_for = id_attr
      label_text = id_attr.titleize
    end

    validators = options[:validators]
  %}

  @{{field_name}} : {{field_type}} = {{field_type.id}}.new(
    id: {{id_attr}},
    name: {{name_attr}},
    attrs: {{extra_attrs}},
    value: {{field_value}},
    required: {{required}},
    {% if validators.nil? %}
      validators: [] of Kemal::FormValidator::Validator,
    {% else %}
      validators: {{validators.id}} of Kemal::FormValidator::Validator,
    {% end %}
    {% if label.nil? %}
      label: Kemal::Form::Label.new({{label_for}}, {{label_text}}, nil))
    {% else %}
      label: {{label}})
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