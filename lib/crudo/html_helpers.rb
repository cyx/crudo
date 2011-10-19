require "rack"

module Crudo
  module HTMLHelpers
    def h(str)
      Rack::Utils.escape_html(str)
    end

    def select_options(pairs, selected = nil, prompt = nil)
      "".tap do |acc|
        acc << option_tag(prompt, "") if prompt

        pairs.each { |label, value| acc << option_tag(label, value, selected) }
      end
    end

    def option_tag(label, value, selected = nil)
      _crudo_partial("form/option", selected: selected, value: value, label: label)
    end

    def datefield(model, field, hint = nil)
      input(model, field, hint) do
        _crudo_partial("form/textfield",
          name: field_name(model, field),
          value: model.send(field),
          class: "date"
        )
      end
    end

    def input_tag(field_name, label, hint = nil)
      _crudo_partial("form/field",
        label: label,
        input: textfield_tag(field_name, nil),
        hint: hint
      )
    end

    def textfield_tag(field_name, value)
      _crudo_partial("form/textfield", name: field_name, value: value)
    end

    def textfield(model, field, hint = nil)
      input(model, field, hint) do
        textfield_tag(field_name(model, field), model.send(field))
      end
    end

    def password_field(model, field, hint = nil)
      input(model, field, hint) do
        _crudo_partial("form/password",
          name: field_name(model, field)
        )
      end
    end

    def filefield(model, field, hint = nil)
      input(model, field, hint) do
        _crudo_partial("form/file",
          name: field_name(model, field)
        )
      end
    end

    def textarea(model, field, hint = nil)
      input(model, field, hint) do
        _crudo_partial("form/textarea",
          name: field_name(model, field),
          value: model.send(field)
        )
      end
    end

    def dropdown(model, field, options, hint = nil)
      input(model, field, hint) do
        _crudo_partial("form/select",
          name: field_name(model, field),
          options: select_options(options, model.send(field))
        )
      end
    end

    def input(model, field, hint)
      _crudo_partial("form/field",
        label: Crudo::Utils.titlecase(field),
        input: yield,
        hint: hint)
    end

    def field_name(model, field)
      "#{Crudo::Utils.underscore(model.class.name)}[#{field}]"
    end
  end
end