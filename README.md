# kemal-form

TODO: Write a description here

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     kemal-form:
       github: henrikac/kemal-form
   ```

2. Run `shards install`

## Usage

**src/main.cr**
```crystal
require "kemal"
require "kemal-form"

class CustomForm < Kemal::Form
  field username : Kemal::Form::TextField, required: true
  field email : Kemal::Form::EmailField
  field age : Kemal::Form::NumberField, attrs: {"min" => "18", "max" => "30"}
  field password : Kemal::Form::PasswordField, required: true
end

get "/" do
  my_form = CustomForm.new
  render "src/views/index.ecr"
end
```

Use `macro render_form(form, method = "GET", action = "")` to render the form in your template.

**src/views/index.ecr**
```erb
<!DOCTYPE html>
<html>
  <head>
    <title>index.ecr</title>
  </head>
  <body>
    <h1>Hello index.ecr</h1>
    <%= render_form my_form, "POST" %>
  </body>
</html>
```

This will output

```html
<!DOCTYPE html>
<html>
  <head>
    <title>index.ecr</title>
  </head>
  <body>
    <h1>Hello index.ecr</h1>
    <form method="POST">
      <label for="username">Username</label>
      <input type="text" id="username" name="username" required/>
      <label for="email">Email</label>
      <input type="email" id="email" username="email"/>
      <label for="age">Age</label>
      <input type="number" id="age" name="age" min="18" max="30"/>
      <label for="password">Password</label>
      <input type="password" id="password" name="password" required/>
    </form>
  </body>
</html>
```

#### Field validators

kemal-form comes with a few field validators that helps making sure that the form data is valid.

```crystal
class MyForm < Kemal::Form
  field name : Kemal::Form::TextField,
                 validators: [
                   Kemal::FormValidator::Required.new,
                   Kemal::FormValidator::Length.new(min: 6, max: 25)
                 ]
end

post "/" do
  form = MyForm.new
  if form.valid?
    puts "form is valid"
  end
  render "src/views/index.ecr"
end
```

| Validator | Description |
| --- | --- |
| `Required` | Validates that the field is not empty |
| `Length` | Validates that the field has a `min` length, `max` length or has a length between `min` and `max` |
| `NumberRange` | Validates that a number has a `min` value, `max` value or has a value between `min` and `max` |

#### Custom field validators

It is easy to create custom field validators if there is a situation where the built-in validators are not sufficient.

```crystal
require "kemal-form"

class CustomValidator < Kemal::FormValidator::Validator
  def validate(field : Kemal::Form::FormField)
    # code ...
    #
    # to indicate that validation failed
    # raise Kemal::Form::ValidationError
  end
end
```

## Contributing

1. Fork it (<https://github.com/henrikac/kemal-form/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Henrik Christensen](https://github.com/henrikac) - creator and maintainer
