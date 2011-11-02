module Crudo
  module Utils
    def self.copy(vars, src, dst)
      vars.each do |var|
        begin
          dst.send(:"#{var}=", src.send(var))
        rescue NoMethodError
          raise NoSettingDefined.new(src, var)
        end
      end
    end

    class NoSettingDefined < StandardError
      attr :app
      attr :var

      def initialize(app, var)
        @app = app
        @var = var
      end

      def message
        MESSAGE % { var: var, app: app }
      end

      MESSAGE = (<<-EOT).gsub(/^ {8}/, "")

        # %{app}.%{var} is missing!

        You need to define `%{var}` on `%{app}`. Do any of the ff:

            class Cuba
              def self.%{var}
                # define the value here
              end
            end

        or by using Cuba::Settings:

            Cuba.plugin Cuba::Settings
            Cuba.set :%{var}, "some value"
      EOT
    end
  end
end