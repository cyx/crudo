module Crudo
  module Helpers
    def namespace
      settings.crudo.namespace
    end

    def model
      settings.crudo.model
    end

    def title
      settings.crudo.title
    end

    def set_attributes(record, attributes)
      attributes.each do |field, value|
        record.send(:"#{field}=", value)
      end
    end

    def save(record, params)
      set_attributes(record, params)

      if record.save
        if session
          session[:success] = settings.crudo.saved_message % record.to_s
        end

        res.redirect url_for(record), 303
      else
        crudo_form(record)
      end
    end

    def crudo_partial(template, locals = {})
      partial(crudo_path("%s.mote" % template), locals)
    end

    def crudo_path(*args)
      File.join(ROOT_DIR, *args)
    end

    def crudo_form(record)
      view(crudo_path("form"), model: record)
    end

    def url_for(model)
      if model.new?
        settings.crudo.url
      else
        "%s/%s" % [settings.crudo.url, model.id]
      end
    end

    def select_options(pairs, selected = nil, prompt = nil)
      "".tap do |ret|
        ret << option_tag(prompt, "") if prompt

        pairs.each do |label, value|
          ret << option_tag(label, value, selected)
        end
      end
    end

    def option_tag(label, value, selected = nil)
      crudo_partial("option", selected: selected, value: value, label: label)
    end

    def datefield(model, field, hint = nil)
      input(model, field, hint) do
        crudo_partial("textfield",
          name: field_name(model, field),
          value: model.send(field),
          class: "date"
        )
      end
    end

    def input_tag(field_name, label, hint = nil)
      crudo_partial("field",
        label: label,
        input: textfield_tag(field_name, nil),
        hint: hint
      )
    end

    def textfield_tag(field_name, value)
      crudo_partial("textfield", name: field_name, value: value)
    end

    def textfield(model, field, hint = nil)
      input(model, field, hint) do
        textfield_tag(field_name(model, field), model.send(field))
      end
    end

    def password_field(model, field, hint = nil)
      input(model, field, hint) do
        crudo_partial("password",
          name: field_name(model, field)
        )
      end
    end

    def filefield(model, field, hint = nil)
      input(model, field, hint) do
        crudo_partial("file",
          name: field_name(model, field)
        )
      end
    end

    def textarea(model, field, hint = nil)
      input(model, field, hint) do
        crudo_partial("textarea",
          name: field_name(model, field),
          value: model.send(field)
        )
      end
    end

    def dropdown(model, field, options, hint = nil)
      input(model, field, hint) do
        crudo_partial("select",
          name: field_name(model, field),
          options: select_options(options, model.send(field))
        )
      end
    end

    def input(model, field, hint, error = nil)
      crudo_partial("field",
        label: Crudo::Utils.titlecase(field),
        input: yield,
        hint: hint,
        error: error)
    end

    def field_name(model, field)
      "#{Crudo::Utils.underscore(model.class.name)}[#{field}]"
    end
  end
end