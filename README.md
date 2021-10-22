# kemal-form

kemal-form is a shard that makes it easy and fun to work with forms in your [Kemal](https://kemalcr.com/) applications.

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

class LoginForm < Kemal::Form
  field username : Kemal::Form::TextField,
                     validators: [Kemal::FormValidator::Required.new]
  field password : Kemal::Form::PasswordField,
                     validators: [Kemal::FormValidator::Required.new]
  button submit : Kemal::Form::SubmitButton,
                    text: "Login"
end

get "/login" do
  form = LoginForm.new
  render "src/views/login.ecr"
end

post "/login" do |env|
  form = LoginForm.new
  if form.valid?
    username = form.body["username"].as(String)
    password = form.body["password"].as(String)
    env.redirect "/"
    next
  end
  render "src/views/login.ecr"
end
```

**src/views/login.ecr**
```erb
<!DOCTYPE html>
<html>
  <head>
    <title>Login</title>
  </head>
  <body>
    <h1>Login</h1>
    <form method="POST">
      <% form.fields.each do |field| %>
        <div>
          <%= field.label %>
          <%= field %>
          <% if !field.errors.empty? %>
            <ul>
              <% field.errors.each do |error| %>
                <li><%= error %></li>
              <% end %>
            </ul>
          <% end %>
        </div>
      <% end %>
      <% form.buttons.each do |button| %>
        <%= button %>
      <% end %>
    </form>
  </body>
</html>
```

This will output

```html
<!DOCTYPE html>
<html>
  <head>
    <title>Login</title>
  </head>
  <body>
    <h1>Login</h1>
    <form method="POST">
      <div>
        <label for="username">Username</label>
        <input type="text" id="username" name="username" required/>
      </div>
      <div>
        <label for="password">Password</label>
        <input type="password" id="password" name="password" required/>
      </div>
      <button type="submit">Login</button>
    </form>
  </body>
</html>
```

The field macro used to generate form fields takes a few optional arguments/options:
+ id: The value of the fields id attribute.
+ name: The value of the fields name attribute.
+ attrs: A hash of extra field attributes.
+ value: The value of the fields value attribute.
+ required: A boolean to signal if the required attribute should be set.
+ validators: An array of field validators.
+ label: The fields label (`Kemal::Form::Label(for, text, attrs)`).

*Note:* The required attribute is only for client-side validation and it will not be checked when `Kemal::Form#valid?` is run.

#### Fields

kemal-form comes with a few built-in fields:
+ `EmailField`
+ `HiddenField`
+ `NumberField`
+ `PasswordField`
+ `TextField`
+ `TextAreaField`
+ `CheckboxField`
+ `RadioField`
+ `SelectField`

Custom fields are easy to create if the built-in fields are not sufficient enough.

```crystal
class CustomField < Kemal::Form::Field
  # code ...

  def to_s(io : IO)
    # how this field should be rendered
  end
end
```

#### Buttons

kemal-form comes with a single button `Kemal::Form::SubmitButton`. However, custom buttons can be created by inheriting from `Kemal::Form::Button`.

#### Field validators

kemal-form comes with a few field validators that helps making sure that the form data is valid.

| Validator | Description |
| --- | --- |
| `Required` | Validates that the field is not empty. Adding this validator to a field will also add the `required` attribute to the field if it has not already been set. |
| `Length` | Validates that the field has a `min` length, `max` length or has a length between `min` and `max` |
| `NumberRange` | Validates that a number has a `min` value, `max` value or has a value between `min` and `max`. Adding this validator will also add the `min` and/or `max` attribute to the field. |
| `Email` | Validates that the field is a valid email |

#### Custom field validators

It is easy to create custom field validators if there is a situation where the built-in validators are not sufficient.

```crystal
require "kemal-form"

class CustomValidator < Kemal::FormValidator::Validator
  def validate(field : Kemal::Form::FormField)
    # code ...
    #
    # to signal that validation failed
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
