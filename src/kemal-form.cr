require "kemal"
require "./kemal-form/**"

module Kemal
  # `Kemal::Form` contains classes and macros that makes working with forms
  # in your Kemal application fun and easy.
  #
  # ```
  # require "kemal"
  # require "kemal-form"
  #
  # class LoginForm < Kemal::Form
  #   field username : Kemal::Form::TextField,
  #                      validators: [Kemal::FormValidator::Required.new]
  #   field password : Kemal::Form::PasswordField,
  #                      validators: [
  #                        Kemal::FormValidator::Length.new(min: 6)
  #                      ]
  #   button login : Kemal::Form::SubmitButton,
  #                    text: "Login"
  # end
  #
  # get "/login" do
  #   form = LoginForm.new
  #   render "src/views/login.ecr"
  # end
  #
  # post "/login" do |env|
  #   form = LoginForm.new env
  #   if form.valid?
  #     puts "You are now logged in"
  #     env.redirect "/"
  #     next
  #   end
  #   render "src/views/login.ecr"
  # end
  # ```
  class Form
    VERSION = "0.3.0"
  end
end
