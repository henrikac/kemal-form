module Kemal
  # `Kemal::FormValidator` is a module that contains a collection of different
  # form field validators.
  #
  # Validators in `Kemal::FormValidator`:
  # + `Kemal::FormValidator::Required`
  # + `Kemal::FormValidator::Length`
  # + `Kemal::FormValidator::NumberRange`
  #
  # Custom validators can be created by making a class inherit from `Kemal::FormValidator::Validator`
  # and implement a custom `def validate(field : Kemal::Form::FormField)`. `validate`
  # should raise a `Kemal::Form::ValidationError` to signal that a validation error has occured.
  #
  # ```
  # class CustomValidator < Kemal::FormValidator::Validator
  #   def validate(field : Kemal::Form::FormField)
  #     # code ....
  #     #
  #     # raise a Kemal::Form::ValidationError to signal that
  #     # a validation error has occured
  #   end
  # end
  # ```
  module FormValidator
    abstract class Validator
      @message : String = ""

      abstract def validate(field : Kemal::Form::FormField)
    end

    # `Kemal::FormValidator::Required` validates that input was provided.
    class Required < Validator
      @message : String = "This field is required"

      def initialize; end

      def initialize(@message); end

      def validate(field : Kemal::Form::FormField)
        raise Kemal::Form::ValidationError.new(@message) if field.value.empty?
      end
    end

    # `Kemal::FormValidator::Length` validates the length of a string.
    class Length < Validator
      @min : Int32
      @max : Int32

      def initialize(@min = -1, @max = -1, @message = "")
        if @min < 1 && @max < 1
          raise ArgumentError.new("At least one of 'min' or 'max' must be specified")
        elsif @max != -1 && @min >= @max
          raise ArgumentError.new("'min' cannot be greater than or equal to 'max'")
        end
      end

      def validate(field : Kemal::Form::FormField)
        str_len = field.value.size
        return if str_len >= @min && (@max == -1 || str_len <= @max)

        if @message.empty?
          if @max == -1
            @message = "Field must be at least #{@min} character#{@min > 1 ? "s" : ""}"
          elsif @min == -1
            @message = "Field cannot be longer than #{@max} character#{@max > 1 ? "s" : ""}"
          elsif @min == @max
            @message = "Field should be #{@max} character#{@max > 1 ? "s" : ""} long"
          else
            @message = "Field must be between #{@min} and #{@max} characters long"
          end
        end

        raise Kemal::Form::ValidationError.new(@message)
      end
    end

    # `Kemal::FormValidator::NumberRange` validates that a number is of a minimum and/or
    # maximum value, inclusive.
    class NumberRange < Validator
      @min : Number::Primitive?
      @max : Number::Primitive?

      def initialize(@min = nil, @max = nil, @message = "")
        if @min.nil? && @max.nil?
          raise ArgumentError.new("At least one of 'min' or 'max' must be specified")
        elsif !@min.nil? && !@max.nil? && @min.not_nil! >= @max.not_nil!
          raise ArgumentError.new("'min' cannot be greater than or equal to 'max'")
        end
      end

      def validate(field : Kemal::Form::FormField)
        field_data = field.value.try &.to_f?
        if field_data.nil?
          raise Kemal::Form::ValidationError.new("Invalid field input")
        end

        return if (@min.nil? || @min.not_nil! <= field_data) && (@max.nil? || @max.not_nil! >= field_data)

        if @message.empty?
          if @max.nil?
            @message = "Number must be greater than or equal to #{@min.not_nil!}"
          elsif @min.nil?
            @message = "Number must be less than or equal to #{@max.not_nil!}"
          else
            @message = "Number must be between #{@min.not_nil!} and #{@max.not_nil!}"
          end
        end

        raise Kemal::Form::ValidationError.new(@message)
      end
    end

    # `Kemal::FormValidator::Email` validates that the input is a valid email.
    # The regex pattern used to validate the email is a non-strict pattern meaning that
    # it only catches common typo errors. However, it is possible to specify another, more strict,
    # pattern if needed.
    #
    # ```
    # Kemal::FormValidator::Email.new
    # Kemal::FormValidator::Email.new(/custom-validation-pattern/)
    # ```
    class Email < Validator
      def initialize(@pattern : Regex = /^\S+@\S+\.\S+$/, @message : String = "Field must be a valid email")
      end

      def validate(field : Kemal::Form::FormField)
        raise Kemal::Form::ValidationError.new(@message) if @pattern.match(field.value).nil?
      end
    end
  end
end