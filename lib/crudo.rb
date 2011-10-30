require "cuba"
require "cuba/contrib"
require "mote"

module Crudo
  autoload :CompileSite, "crudo/compile_site"
  autoload :Config,      "crudo/config"
  autoload :Handler,     "crudo/handler"
  autoload :Helpers,     "crudo/helpers"
  autoload :Utils,       "crudo/utils"

  ROOT_DIR = File.expand_path("crudo/views", File.dirname(__FILE__))

  def CRUD(model, url, &block)
    crudo_compile(model) do
      config = Config.new(model, url, &block)

      app = self.class.build
      app.plugin Cuba::Settings
      app.helper Crudo::Helpers

      app.use Rack::MethodOverride

      app.set :crudo, config
      app.set :views, self.class.views
      app.set :layout, self.class.layout
      app.set :saved_message, "You have successfully saved %s."

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