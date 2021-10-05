module Kemal
  abstract class FormField
    @type : String = ""
    @attrs : Hash(String, String)
    @required : Bool

    def initialize(@attrs, @required = false)
    end

    # abstract def valid? : Bool

    def to_s(io : IO)
      io << "<input type=\""
      io << @type
      io << "\""
      if !@attrs.empty?
        @attrs.each { |k,v| io << " #{k}=\"#{v}\"" }
      end
      io << " required" if @required
      io << "/>"
    end
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
      if !@attrs.empty?
        @attrs.each { |k, v| io << " #{k}=\"#{v}\"" }
      end
      io << " required" if @required
      io << "></textarea>"
    end
  end
end