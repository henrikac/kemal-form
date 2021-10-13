require "./spec_helper"

describe "Kemal::Form::Label" do
  it "should create and render a label" do
    label = Kemal::Form::Label.new("username", "Username", nil)
    expected = "<label for=\"username\">Username</label>"
    label.should_not be_nil
    typeof(label).should eq Kemal::Form::Label
    label.to_s.should eq expected
  end

  it "should render extra attributes" do
    extra_attrs = {"class" => "label-class"}
    label = Kemal::Form::Label.new("username", "Username", extra_attrs)
    expected = "<label for=\"username\" class=\"label-class\">Username</label>"
    label.to_s.should eq expected
  end
end