module Kemal
  module FormValidator
    abstract class Validator
      @message : String = ""

      abstract def validate(field : Kemal::Form::FormField)
    end

    class Required < Validator
      @message : String = "This field is required"

      def initialize; end

      def initialize(@message); end

      def validate(field : Kemal::Form::FormField)
        raise Kemal::Form::ValidationError.new(@message) if field.value.empty?
      end
    end

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

    class NumberRange < Validator
      @min : Number::Primitive?
      @max : Number::Primitive?

      def initialize(@min = nil, @max = nil, @message = "")
        if @min.nil? && @max.nil?
          raise ArgumentError.new("At least one of 'min' or 'max' must be specified")
        elsif !@max.nil? && @min.not_nil! >= @max.not_nil!
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
  end
end