$:.unshift(File.expand_path("../lib", File.dirname(__FILE__)))

require "crudo"
require "cuba/test"
require "ohm"

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