$:.unshift(File.expand_path("../lib", File.dirname(__FILE__)))

require "cuba/test"
require "override"

require_relative "../lib/crudo"

TEST_DIR = File.dirname(__FILE__)

class Cutest::Scope
  include Override
end

class Cuba
  include Crudo
  include Mote::Helpers

  def partial(template, locals = {})
    mote(File.join(TEST_DIR, "views/#{template}.mote"), locals)
  end

  def view(template, locals = {})
    partial("layout", {
      content: partial(template, locals),
      session: session
    }.merge(locals))
  end
end