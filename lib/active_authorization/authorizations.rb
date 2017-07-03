# frozen_string_literal: true

module ActiveAuthorization
  module Authorizations
    def self.list=(arry)
      @list = arry
    end

    def self.list
      @list
    end

    self.list = []
  end
end
