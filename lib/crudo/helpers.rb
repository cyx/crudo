module Crudo
  module Helpers
    def namespace
      @_namespace ||= underscore(settings.crudo.model.name)
    end

    def title
      @_title ||= titlecase(settings.crudo.model.name)
    end

    def model
      settings.crudo.model
    end

    def set_attributes(record, attributes)
      attributes.each do |field, value|
        record.send(:"#{field}=", value)
      end
    end

    def dropdown_using_lambda(model, field, closure, hint = nil)
      input(model, field, hint) do
        cuba_contrib_partial("select",
          name: field_name(model, field),
          options: select_options(closure.call, model.send(field))
        )
      end
    end

    def crudo_form(record)
      view(File.expand_path("views/form.mote", CRUDO_ROOT),
           model: record, title: title)
    end

    def save(record, params)
      set_attributes(record, params)

      if record.save
        if session
          session[:success] = settings.saved_message % record.to_s
        end

        res.redirect url_for(record), 303
      else
        res.write crudo_form(record)
      end
    end

    def url_for(model)
      if model.new?
        settings.crudo.url
      else
        "%s/%s" % [settings.crudo.url, model.id]
      end
    end
  end
end