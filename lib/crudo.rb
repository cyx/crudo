require "cuba"
require "mote"

module Crudo
  ROOT = File.dirname(__FILE__)

  autoload :Config,      "crudo/config"
  autoload :HTMLHelpers, "crudo/html_helpers"
  autoload :Sieve,       "crudo/sieve"
  autoload :Utils,       "crudo/utils"

  def self.included(app)
    app.send :include, HTMLHelpers
  end

  def _crudo_partial(template, locals = {})
    mote(File.expand_path("../views/#{template}.mote", ROOT), locals)
  end

  def session
    env["rack.session"]
  end

  def CRUD(model, url)
    config = Crudo::Config.new(model, url)

    yield config

    self.class.new {
      @url = url
      @config = config
      @namespace = config.namespace

      def crud_form(record)
        partial("layout", {
          session: session,
          content: _crudo_partial("crud-form",
            model:  record,
            config: @config,
            title:  @config.title,
            cancel: @config.url,
            namespace: @config.namespace)
        })
      end

      def url_for(model)
        if model.new?
          @url
        else
          "#{@url}/#{model.id}"
        end
      end

      def validator(type, params)
        @config.validators[type].new(params)
      end

      def save(record, guard)
        if guard.valid?
          record.update(guard.attributes)

          session[:success] = "You have successfully saved #{record.to_s}."
          res.redirect "#{@url}/#{record.id}", 303
        else
          res.write crud_form(record)
        end
      end

      on get do
        on "add" do
          res.write crud_form(model.new)
        end

        on :id do |id|
          res.write crud_form(model[id])
        end

        on default do
          res.write view("#{@namespace}/list", records: model.all)
        end
      end

      on post do
        on :id, param(@namespace) do |id, params|
          save model[id], validator(:update, params)
        end

        on param(@namespace) do |params|
          save model.new, validator(:create, params)
        end
      end

      on delete, :id do |id|
        model[id].delete

        on req.xhr? do
          res.write({ redirect: req.referer }.to_json)
        end

        on default do
          res.redirect @url, 303
        end
      end
    }
  end
end