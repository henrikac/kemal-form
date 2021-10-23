require "./spec_helper"

describe "Form" do
  it "should render form in view" do
    get "/" do |env|
      form = CustomForm.new
      render "#{__DIR__}/asset/login.ecr", "#{__DIR__}/asset/layout.ecr"
    end
    request = HTTP::Request.new("GET", "/")
    client_response = call_request_on_app(request)
    client_response.body.should contain("form")
    client_response.body.should contain("input")
    client_response.body.should contain("textarea")
  end

  it "... if form is valid" do
    get "/" do |env|
      form = CustomValidationForm.new
      render "#{__DIR__}/asset/login.ecr", "#{__DIR__}/asset/layout.ecr"
    end

    post "/" do |env|
      env.params.body["name"] = "Alice"
      env.params.body["password"] = "supersecret"
      form = CustomValidationForm.new env
      if form.valid?
        env.redirect "/"
        next
      end
      render "#{__DIR__}/asset/login.ecr", "#{__DIR__}/asset/layout.ecr"
    end
    request = HTTP::Request.new("POST", "/")
    client_response = call_request_on_app(request)
    client_response.body.should_not contain("value=\"Alice\"")
  end

  it "re-renders page without deleting values from form fields if form is not valid" do
    post "/" do |env|
      env.params.body["name"] = "Alice"
      env.params.body["password"] = "test"
      form = CustomValidationForm.new env
      if form.valid?
        puts "should not get here"
        env.redirect "/"
      end
      render "#{__DIR__}/asset/login.ecr", "#{__DIR__}/asset/layout.ecr"
    end
    request = HTTP::Request.new("POST", "/")
    client_response = call_request_on_app(request)
    client_response.body.should contain("value=\"Alice\"")
    client_response.body.should contain("Field must be at least 6 characters")
  end
end
