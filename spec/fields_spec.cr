require "./spec_helper"

describe "Kemal::Form::Field" do
  {% begin %}
    {% fields = %w(checkbox email hidden number password radio text) %}
    {% for field in fields %}
      describe "{{field.id.stringify.titleize.id}}Field" do
        it "has type, id and name attributes" do
          {{field.id}}_field = Kemal::Form::{{field.id.stringify.titleize.id}}Field.new(
            id: "{{field.id}}_field",
            name: "{{field.id}}_field",
            value: "",
            required: false)
          expected = "<input type=\"{{field.id}}\" id=\"{{field.id}}_field\" name=\"{{field.id}}_field\" value=\"\"/>"

          {{field.id}}_field.to_s.should eq expected
        end

        it "renders extra attributes" do
          {{field.id}}_field = Kemal::Form::{{field.id.stringify.titleize.id}}Field.new(
            id: "{{field.id}}_field",
            name: "{{field.id}}_field",
            value: "",
            attrs: {"class" => "custom-class"},
            required: false)
          expected = "<input type=\"{{field.id}}\" id=\"{{field.id}}_field\" name=\"{{field.id}}_field\" class=\"custom-class\" value=\"\"/>"

          {{field.id}}_field.to_s.should eq expected
        end

        it "has required attribute if required is set to true" do
          {{field.id}}_field = Kemal::Form::{{field.id.stringify.titleize.id}}Field.new(
            id: "{{field.id}}_field",
            name: "{{field.id}}_field",
            value: "",
            required: true)
          expected = "<input type=\"{{field.id}}\" id=\"{{field.id}}_field\" name=\"{{field.id}}_field\" value=\"\" required/>"
          
          {{field.id}}_field.to_s.should eq expected
        end

        it "should have required attribute if given a Kemal::FormValidator::Required" do
          {{field.id}}_field = Kemal::Form::{{field.id.stringify.titleize.id}}Field.new(
            id: "{{field.id}}_field",
            name: "{{field.id}}_field",
            value: "",
            required: false,
            validators: [Kemal::FormValidator::Required.new] of Kemal::FormValidator::Validator)
          expected = "<input type=\"{{field.id}}\" id=\"{{field.id}}_field\" name=\"{{field.id}}_field\" value=\"\" required/>"

          {{field.id}}_field.to_s.should eq expected
        end

        {% if field.id.stringify == "checkbox" || field.id.stringify == "radio" %}
          it "is not checked by default" do
            {{field.id}}_field = Kemal::Form::{{field.id.stringify.titleize.id}}Field.new(
              id: "{{field.id}}_field",
              name: "{{field.id}}_field",
              value: "",
              required: false)
            
            {{field.id}}_field.checked.should be_false
          end

          it "has checked attribute if checked is set to true" do
            {{field.id}}_field = Kemal::Form::{{field.id.stringify.titleize.id}}Field.new(
              id: "{{field.id}}_field",
              name: "{{field.id}}_field",
              value: "",
              required: true)
            {{field.id}}_field.checked = true
            expected = "<input type=\"{{field.id}}\" id=\"{{field.id}}_field\" name=\"{{field.id}}_field\" value=\"\" checked required/>"
            
            {{field.id}}_field.to_s.should eq expected
          end
        {% end %}
      end
    {% end %}
  {% end %}

  describe "NumberField" do
    it "should have min attribute set if NumberRange validator specifies a min" do
      num_field = Kemal::Form::NumberField.new(
        id: "num_field",
        name: "num_field",
        value: "",
        required: false,
        validators: [Kemal::FormValidator::NumberRange.new(min: 13)] of Kemal::FormValidator::Validator)

        num_field.to_s.should contain("min=\"13\"")
        num_field.to_s.should_not contain("max=")
    end

    it "should have max attribute set if NumberRange validator specifies a max" do
      num_field = Kemal::Form::NumberField.new(
        id: "num_field",
        name: "num_field",
        value: "",
        required: false,
        validators: [Kemal::FormValidator::NumberRange.new(max: 13)] of Kemal::FormValidator::Validator)

        num_field.to_s.should contain("max=\"13\"")
        num_field.to_s.should_not contain("min=")
    end

    it "should have min and max attribute set if NumberRange validator specifies a min and max" do
      num_field = Kemal::Form::NumberField.new(
        id: "num_field",
        name: "num_field",
        value: "",
        required: false,
        validators: [Kemal::FormValidator::NumberRange.new(min: 13, max: 50)] of Kemal::FormValidator::Validator)

        num_field.to_s.should contain("min=\"13\"")
        num_field.to_s.should contain("max=\"50\"")
    end
  end

  describe "TextAreaField" do
    it "has id and name attributes" do
      textarea = Kemal::Form::TextAreaField.new(
        id: "textarea",
        name: "textarea",
        value: "",
        required: false)
      expected = "<textarea id=\"textarea\" name=\"textarea\"></textarea>"

      textarea.to_s.should eq expected
    end

    it "renders extra attributes" do
      textarea = Kemal::Form::TextAreaField.new(
        id: "textarea",
        name: "textarea",
        value: "",
        attrs: {"col" => "5", "row" => "7"},
        required: false)
      expected = "<textarea id=\"textarea\" name=\"textarea\" col=\"5\" row=\"7\"></textarea>"

      textarea.to_s.should eq expected
    end

    it "has required attribute if required is set to true" do
      textarea = Kemal::Form::TextAreaField.new(
        id: "textarea",
        name: "textarea",
        value: "",
        required: true)
      expected = "<textarea id=\"textarea\" name=\"textarea\" required></textarea>"

      textarea.to_s.should eq expected
    end
  end

  describe "SelectField" do
    it "renders an empty select if no options given" do
      select_field = Kemal::Form::SelectField.new(
        id: "select_field",
        name: "select_field",
        value: "",
        required: false,
        label: nil)
      expected = "<select id=\"select_field\" name=\"select_field\"></select>"
      
      select_field.options.size.should eq 0
      select_field.to_s.should eq expected
    end

    it "renders a select with given options" do
      select_options = [
        Kemal::Form::SelectField::Option.new("blue"),
        Kemal::Form::SelectField::Option.new("green"),
        Kemal::Form::SelectField::Option.new("red")
      ]
      select_field = Kemal::Form::SelectField.new(
        id: "select_field",
        name: "select_field",
        value: "",
        required: false,
        label: nil,
        options: select_options)
      expected = "<select id=\"select_field\" name=\"select_field\">" \
      "<option value=\"blue\">blue</option>" \
      "<option value=\"green\">green</option>" \
      "<option value=\"red\">red</option>" \
      "</select>"

      select_field.options.size.should eq 3
      select_field.to_s.should eq expected
    end
  end
end