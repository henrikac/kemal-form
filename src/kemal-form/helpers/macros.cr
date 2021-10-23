# Generates a button field for a `Kemal::Form` class. A button can take 2 optional
# arguments/options; text and args.
#
# text: The text content of the button.
# args: A hash of attributes to add to the button.
#
# ```
# class CustomForm < Kemal::Form
#   button submit : Kemal::Form::SubmitButton,
#                   text: "Login",
#                   args: {"class" => "btn btn-primary"}
# end
# ```
macro button(decl, **options)
  {% raise "must be type Kemal::Form::Button" unless decl.type.resolve < Kemal::Form::Button %}
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

# Generates a field for a `Kemal::Form` class. A field can take a couple of optional
# arguments/options; id, name, attrs, value, required, validators and label.
#
# id: The value of the id attribute.
# name: The value of the name attribute.
# attrs: A hash of additional attributes to add to the field.
# value: The value of the field.
# required: A boolean that tells if the required attribute should be added to the field (default: false).
# validators: An array of `Kemal::FormValidator::Validator`.
# label: Custom field label (`Kemal::Form::Label`).
#
# ```
# class CustomForm < Kemal::Form
#   field name : Kemal::Form::TextField
# end
# ```
macro field(decl, **opts)
  {% raise "must be type Kemal::Form::Field" unless decl.type.resolve < Kemal::Form::Field %}
  {%
    field_name = decl.var
    field_type = decl.type

    id_attr = opts[:id]
    if id_attr.nil?
      id_attr = field_name.id.stringify
    end

    name_attr = opts[:name]
    if name_attr.nil?
      name_attr = field_name.id.stringify
    end

    extra_attrs = opts[:attrs]

    field_value = opts[:value]
    if field_value.nil?
      field_value = ""
    end

    required = opts[:required] == true

    label = opts[:label]
    validators = opts[:validators]
  %}

  @{{field_name}} : {{field_type}} = {{field_type.id}}.new(
    id: {{id_attr}},
    name: {{name_attr}},
    value: {{field_value}},
    required: {{required}},
    label: {{label}},
    {% if !extra_attrs.nil? %}
      attrs: {{extra_attrs}},
    {% end %}
    {% if !validators.nil? %}
      validators: {{validators.id}} of Kemal::FormValidator::Validator,
    {% end %}
    {% if field_type.resolve == Kemal::Form::SelectField && !opts[:options].nil? %}
      options: {{opts[:options]}},
    {% end %}
  )

  def {{field_name.id}} : {{field_type.id}}
    @{{field_name}}
  end
end
