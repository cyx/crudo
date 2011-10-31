$:.unshift(File.expand_path("../lib", File.dirname(__FILE__)))

require "crudo"
require "cuba/test"
require "ohm"

# We patch Ohm to use the newer and better validation system
# protocol: model.errors[field] == [:not_present, :not_unique]
module Ohm
  module Validations
    def errors
      @errors ||= Hash.new { |hash, key| hash[key] = [] }
    end

    def assert(value, error)
      value or errors[error.first].push(error.last) && false
    end
  end
end

prepare do
  Ohm.connect db: 15
  Ohm.flush
end

class Cutest::Scope
  def xhr(verb, path, params = {})
    page.driver.send(verb, path, params,
                     "HTTP_X_REQUESTED_WITH" => "XMLHttpRequest")
  end
end