require "http"

module Kemal
  class Form
    @fields : Array(Kemal::FormField)

    def initialize(@ctx : HTTP::Server::Context? = nil)
      @fields = get_form_fields
    end
    
    def to_s(io : IO)
      @fields.each_with_index do |field, idx|
        io << field
      end
    end

    private def get_form_fields : Array(Kemal::FormField)
      {{ @type.instance_vars.select { |ivar| ivar.type < Kemal::FormField } }}
    end
  end
end