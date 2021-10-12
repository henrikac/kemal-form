require "./spec_helper"

class TestValidator < Kemal::Form
  field username : Kemal::Form::TextField
  field email : Kemal::Form::EmailField
  field age : Kemal::Form::NumberField
end

describe "Kemal::FormValidator::Validator" do
  describe "Required" do
    it "should pass if field is not empty" do
      form = TestValidator.new
      form.username.value = "testname"
      validator = Kemal::FormValidator::Required.new

      validator.validate(form.username).should be_nil
    end

    it "should raise a validation error if field is empty" do
      form = TestValidator.new
      validator = Kemal::FormValidator::Required.new

      expect_raises(Kemal::Form::ValidationError) do
        validator.validate(form.username)
      end
    end

    it "should give custom error message" do
      form = TestValidator.new
      error_message = "Username is required"
      validator = Kemal::FormValidator::Required.new(error_message)

      expect_raises(Kemal::Form::ValidationError, error_message) do
        validator.validate(form.username)
      end
    end
  end

  describe "Length" do
    it "should pass if length of value is greater than or equal to min (max not set)" do
      values = ["hello", "world", "bob", "was", "here", "maybe"]
      form = TestValidator.new
      validator = Kemal::FormValidator::Length.new(min: 3)

      values.each do |value|
        form.username.value = value
        validator.validate(form.username).should be_nil
      end
    end

    it "should pass if length of value is less than or equal to max (min not set)" do
      values = ["hello", "world", "", "bob", "was", "here", "maybe"]
      form = TestValidator.new
      validator = Kemal::FormValidator::Length.new(max: 5)

      values.each do |value|
        form.username.value = value
        validator.validate(form.username).should be_nil
      end
    end

    it "should pass if length value is between min and max" do
      values = ["hello", "world", "bob", "was", "here", "maybe"]
      form = TestValidator.new
      validator = Kemal::FormValidator::Length.new(min: 3, max: 5)

      values.each do |value|
        form.username.value = value
        validator.validate(form.username).should be_nil
      end
    end

    it "should give custom error message" do
      error_message = "username should be minimum 5 characters long"
      form = TestValidator.new
      validator = Kemal::FormValidator::Length.new(min: 5, message: error_message)

      form.username.value = "bob"

      expect_raises(Kemal::Form::ValidationError, error_message) do
        validator.validate(form.username)
      end
    end

    it "should raise a validation error if length of value is less than min" do
      form = TestValidator.new
      validator = Kemal::FormValidator::Length.new(min: 5)

      form.username.value = "sue"

      expect_raises(Kemal::Form::ValidationError) do
        validator.validate(form.username)
      end
    end

    it "should raise a validation error if length of value is greater than max" do
      form = TestValidator.new
      validator = Kemal::FormValidator::Length.new(max: 5)

      form.username.value = "alice-bob"

      expect_raises(Kemal::Form::ValidationError) do
        validator.validate(form.username)
      end
    end

    it "should raise an argument error if neither min or max is set" do
      expect_raises(ArgumentError) do
        Kemal::FormValidator::Length.new
      end
    end

    it "should raise an argument error if min is greater than or equal to max" do
      min_max = [
        { min: 5, max: 5 },
        { min: 7, max: 3}
      ]

      min_max.each do |mm|
        expect_raises(ArgumentError) do
          Kemal::FormValidator::Length.new(mm[:min], mm[:max])
        end
      end
    end
  end

  describe "NumberRange" do
    it "should pass if value is greater than or equal to min (max not set)" do
      values = [21, 18, 29, 51]
      form = TestValidator.new
      validator = Kemal::FormValidator::NumberRange.new(min: 18)

      values.each do |value|
        form.age.value = value.to_s
        validator.validate(form.age).should be_nil
      end
    end

    it "should pass if value is less than or equal to max (min not set)" do
      values = [21, 18, 29, 50]
      form = TestValidator.new
      validator = Kemal::FormValidator::NumberRange.new(max: 50)

      values.each do |value|
        form.age.value = value.to_s
        validator.validate(form.age).should be_nil
      end
    end

    it "should pass if value if between min and max" do
      values = [21, 18, 29, 30]
      form = TestValidator.new
      validator = Kemal::FormValidator::NumberRange.new(min: 18, max: 30)

      values.each do |value|
        form.age.value = value.to_s
        validator.validate(form.age).should be_nil
      end
    end

    it "should raise a validation error if value is not a valid number" do
      values = ["", "32f", "alice"]
      form = TestValidator.new
      validator = Kemal::FormValidator::NumberRange.new(min: 3)

      values.each do |value|
        form.age.value = value
        expect_raises(Kemal::Form::ValidationError) do
          validator.validate(form.age)
        end
      end
    end

    it "should raise a validation error if value is less than min" do
      form = TestValidator.new
      validator = Kemal::FormValidator::NumberRange.new(min: 5)

      form.age.value = "3"

      expect_raises(Kemal::Form::ValidationError) do
        validator.validate(form.age)
      end
    end

    it "should raise a validation error if value is greater than max" do
      form = TestValidator.new
      validator = Kemal::FormValidator::NumberRange.new(max: 5)

      form.age.value = "7"

      expect_raises(Kemal::Form::ValidationError) do
        validator.validate(form.age)
      end
    end

    it "should raise an argument error if neither of min and max are set" do
      expect_raises(ArgumentError) do
        Kemal::FormValidator::NumberRange.new
      end
    end

    it "should raise an argument error if min if greater than or equal to max" do
      min_max = [
        { min: 5, max: 5 },
        { min: 7, max: 3}
      ]

      min_max.each do |mm|
        expect_raises(ArgumentError) do
          Kemal::FormValidator::NumberRange.new(mm[:min], mm[:max])
        end
      end
    end
  end
end