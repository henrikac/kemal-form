module Kemal
  class Form
    class FormError < Exception
    end

    class ValidationError < FormError
      def initialize(message, cause = nil)
        super message, cause
      end
    end
  end
end