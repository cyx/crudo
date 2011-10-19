module Crudo
  class Config
    attr :url
    attr :title
    attr :fields
    attr :partials
    attr :validators
    attr :namespace

    def initialize(model, url)
      @model = model
      @url = url
      @namespace = Crudo::Utils.underscore(model.name)
      @title = Crudo::Utils.titlecase(namespace)
      @fields = []
      @partials = Hash.new { |h, k| h[k] = [] }
      @validators = Hash.new { |h, k| h[k] = Sieve }
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
      fields << [:dropdown, *args]
    end

    def textarea(*args)
      fields << [:textarea, *args]
    end

    def filefield(*args)
      fields << [:filefield, *args]
    end

    def partial(where, template, locals = {})
      partials[where] << [template, locals] unless partials[where].include?([template, locals])
    end

    def validate(action, validator)
      validators[action] = validator
    end
  end
end