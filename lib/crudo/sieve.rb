require "ostruct"

module Crudo
  class Sieve < OpenStruct
    def valid?
      true
    end

    def attributes
      @table
    end
  end
end