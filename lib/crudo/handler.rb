require "json"

module Crudo
  Handler = Proc.new do
    on get do
      on "add" do
        res.write crudo_form(model.new)
      end

      on :id do |id|
        res.write crudo_form(model[id])
      end

      on default do
        res.write view("#{namespace}/list", records: model.all, title: title)
      end
    end

    on post do
      on :id, param(namespace) do |id, params|
        save model[id], params
      end

      on param(namespace) do |params|
        save model.new, params
      end
    end

    on delete, :id do |id|
      model[id].delete

      on req.xhr? do
        res.write(JSON.dump(redirect: req.referer || settings.crudo.url))
      end

      on default do
        res.redirect settings.crudo.url, 303
      end
    end
  end
end