module Kemal
  class Form
    # Generic form error.
    class FormError < Exception
    end

    # Error raised on a validation error.
    class ValidationError < FormError
      def initialize(message, cause = nil)
        super message, cause
      end
    end
  end
end