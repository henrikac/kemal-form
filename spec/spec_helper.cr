require "spec"
require "../src/kemal-form"

include Kemal

class CustomForm < Form
  field name : TextField
  field age : NumberField, attrs: {"min" => "18", "max" => "30"}
  field password : PasswordField
  field message : TextAreaField, attrs: {"row" => "7", "col" => "5"}, required: false
end

class CustomValidationForm < Form
  field name : TextField, validators: [FormValidator::Required.new]
  field password : PasswordField, validators: [FormValidator::Length.new(min: 6)]
end

def build_main_handler
  Kemal.config.setup
  main_handler = Kemal.config.handlers.first
  current_handler = main_handler
  Kemal.config.handlers.each do |handler|
    current_handler.next = handler
    current_handler = handler
  end
  main_handler
end

def call_request_on_app(request)
  io = IO::Memory.new
  response = HTTP::Server::Response.new(io)
  context = HTTP::Server::Context.new(request, response)
  main_handler = build_main_handler
  main_handler.call context
  response.close
  io.rewind
  HTTP::Client::Response.from_io(io, decompress: false)
end

Spec.before_each do
  config = Kemal.config
  config.env = "development"
  config.logging = false
end

Spec.after_each do
  Kemal.config.clear
  Kemal::RouteHandler::INSTANCE.routes = Radix::Tree(Route).new
  Kemal::RouteHandler::INSTANCE.cached_routes = Hash(String, Radix::Result(Route)).new
  Kemal::WebSocketHandler::INSTANCE.routes = Radix::Tree(WebSocket).new
end
