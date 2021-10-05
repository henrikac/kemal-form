require "./spec_helper"

describe "Forms" do
  it "should render form in view" do
    get "/" do |env|
      form = CustomForm.new
      render "#{__DIR__}/asset/index.ecr", "#{__DIR__}/asset/layout.ecr"
    end
    request = HTTP::Request.new("GET", "/")
    client_response = call_request_on_app(request)
    client_response.body.should contain("form")
    client_response.body.should contain("input")
    client_response.body.should contain("textarea")
  end
end
