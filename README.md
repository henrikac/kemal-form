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
  field username : Kemal::TextField, required: false
  field email : Kemal::EmailField
  field age : Kemal::NumberField, attrs: {"min" => "18", "max" => "30"}
  field password : Kemal::PasswordField
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

## Contributing

1. Fork it (<https://github.com/henrikac/kemal-form/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Henrik Christensen](https://github.com/henrikac) - creator and maintainer
