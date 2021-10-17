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
            attrs: nil,
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

        {% if field.id.stringify == "checkbox" || field.id.stringify == "radio" %}
          it "is not checked by default" do
            {{field.id}}_field = Kemal::Form::{{field.id.stringify.titleize.id}}Field.new(
              id: "{{field.id}}_field",
              name: "{{field.id}}_field",
              value: "",
              attrs: nil,
              required: false)
            
            {{field.id}}_field.checked.should be_false
          end

          it "has checked attribute if checked is set to true" do
            {{field.id}}_field = Kemal::Form::{{field.id.stringify.titleize.id}}Field.new(
              id: "{{field.id}}_field",
              name: "{{field.id}}_field",
              value: "",
              attrs: nil,
              required: true)
            {{field.id}}_field.checked = true
            expected = "<input type=\"{{field.id}}\" id=\"{{field.id}}_field\" name=\"{{field.id}}_field\" value=\"\" checked/>"
            
            {{field.id}}_field.to_s.should eq expected
          end
        {% else %}
          it "has required attribute if required is set to true" do
            {{field.id}}_field = Kemal::Form::{{field.id.stringify.titleize.id}}Field.new(
              id: "{{field.id}}_field",
              name: "{{field.id}}_field",
              value: "",
              attrs: nil,
              required: true)
            expected = "<input type=\"{{field.id}}\" id=\"{{field.id}}_field\" name=\"{{field.id}}_field\" required value=\"\"/>"
            
            {{field.id}}_field.to_s.should eq expected
          end
        {% end %}
      end
    {% end %}
  {% end %}
end