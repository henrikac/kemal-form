require "http"

module Kemal
  class Form
    @fields : Array(FormField)

    def initialize(@ctx : HTTP::Server::Context? = nil)
      @fields = get_form_fields
    end

    def valid?
      is_valid = true
      @fields.each do |field|
        if field.validate == false
          is_valid = false
        end
      end
      return is_valid
    end
    
    def to_s(io : IO)
      @fields.each_with_index do |field, idx|
        io << field
      end
    end

    private def get_form_fields : Array(FormField)
      {{ @type.instance_vars.select { |ivar| ivar.type < FormField } }}
    end
  end
end