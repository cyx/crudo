module Crudo
  class Config
    attr :model
    attr :url
    attr :fields
    attr :partials

    attr_accessor :saved_message

    def initialize(model, url)
      @model    = model
      @url      = url
      @fields   = []
      @partials = Hash.new { |h, k| h[k] = {} }

      yield self if block_given?
    end

    def textfield(*args)
      fields << [:textfield, *args]
    end

    def datefield(*args)
      fields << [:datefield, *args]
    end

    def password_field(*args)
      fields << [:password_field, *args]
    end

    def dropdown(*args)
      fields << [:dropdown_using_lambda, *args]
    end

    def textarea(*args)
      fields << [:textarea, *args]
    end

    def filefield(*args)
      fields << [:filefield, *args]
    end

    def partial(where, template, closure = nil)
      partials[where][template] = closure || lambda { Hash.new }
    end
  end
end