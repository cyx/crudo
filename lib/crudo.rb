require "cuba"
require "cuba/contrib"
require "mote"

module Crudo
  autoload :CompileSite, "crudo/compile_site"
  autoload :Config,      "crudo/config"
  autoload :Handler,     "crudo/handler"
  autoload :Helpers,     "crudo/helpers"
  autoload :Utils,       "crudo/utils"

  CRUDO_ROOT = File.expand_path("../", File.dirname(__FILE__))

  def CRUD(model, url, &block)
    crudo_compile(model) do
      config = Config.new(model, url, &block)

      app = self.class.build
      app.plugin Cuba::Settings
      app.helper Cuba::TextHelpers
      app.helper Cuba::FormHelpers
      app.helper Crudo::Helpers

      app.use Rack::MethodOverride

      app.set :crudo, config

      Crudo::Utils.copy([:views, :layout, :localized_errors], self.class, app)

      app.set :saved_message, config.saved_message || "You have successfully saved %s."

      app.define(&Handler)

      app
    end
  end

private
  def crudo_compile(model)
    return CompileSite[model] if CompileSite.defined?(model)

    CompileSite[model] = yield
  end
end
