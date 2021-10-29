require "./spec_helper"

describe "Kemal::Form::Button" do
  describe "SubmitButton" do
    it "should create and render a submit button" do
      btn = Kemal::Form::SubmitButton.new("Submit")
      expected = "<button type=\"submit\">Submit</button>"
      btn.should_not be_nil
      typeof(btn).should eq Kemal::Form::SubmitButton
      btn.to_s.should eq expected
    end

    it "should render extra attributes" do
      extra_attrs = {"class" => "btn-class"}
      btn = Kemal::Form::SubmitButton.new("Submit", extra_attrs)
      expected = "<button type=\"submit\" class=\"btn-class\">Submit</button>"
      btn.to_s.should eq expected
    end
  end
end
