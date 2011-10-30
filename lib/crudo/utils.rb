module Crudo
  module Utils
    def self.titlecase(str)
      str.to_s.tr("_", " ").gsub(/(^|\s)([a-z])/) { |char| char.upcase }
    end

    def self.underscore(str)
      str.gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').downcase
    end
  end
end