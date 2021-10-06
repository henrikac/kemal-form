macro field(decl, **options)
  {%
    field_name = decl.var
    field_type = decl.type
    attrs = options[:attrs]
    required = true
    if options[:required] == false
      required = false
    end
  %}

  @{{field_name}} : {{field_type}} = {{field_type.id}}.new({{field_name.id.stringify}}, {{attrs}}, {{required}})

  def {{field_name.id}} : {{field_type.id}}
    @{{field_name}}
  end
end

module Kemal
  abstract class FormField
    @type : String = ""
    @id : String
    @name : String
    @attrs : Hash(String, String)?
    @required : Bool

    def initialize(field_name : String, @attrs, @required = false)
      @id = field_name
      @name = field_name
      if !@attrs.nil?
        a = @attrs.not_nil!
        a.delete("required")
        if a.has_key?("id") && !a["id"].empty?
          @id = a.delete("id").not_nil!
        end
        if a.has_key?("name") && !a["name"].empty?
          @name = a.delete("name").not_nil!
        end
      end
    end

    def to_s(io : IO)
      io << "<input id=\"#{@id}\" name=\"#{@name}\" type=\"#{@type}\""
      if !@attrs.nil? && !@attrs.not_nil!.empty?
        @attrs.not_nil!.each { |k,v| io << " #{k}=\"#{v}\"" }
      end
      io << " required" if @required
      io << "/>"
    end
  end

  class EmailField < FormField
    @type : String = "email"
  end

  class NumberField < FormField
    @type : String = "number"
  end

  class PasswordField < FormField
    @type : String = "password"
  end

  class TextField < FormField
    @type : String = "text"
  end

  class TextAreaField < FormField
    def to_s(io : IO)
      io << "<textarea"
      if !@attrs.nil? && !@attrs.not_nil!.empty?
        @attrs.not_nil!.each { |k, v| io << " #{k}=\"#{v}\"" }
      end
      io << " required" if @required
      io << "></textarea>"
    end
  end
end