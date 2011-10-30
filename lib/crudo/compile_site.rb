module Crudo
  module CompileSite
    def self.defined?(model)
      const_defined?(intern(model), false)
    end

    def self.[](model)
      const_get intern(model)
    end

    def self.[]=(model, value)
      const_set intern(model), value
    end

    def self.intern(model)
      model.name.to_sym
    end
    private_class_method :intern
  end
end