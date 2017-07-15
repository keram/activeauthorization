# frozen_string_literal: true

module Authorizations
  module AuthorizableObject
    class CustomerAuthorization < ActiveAuthorization::Authorization
      def make_a_tea?
        true
      end
    end
  end
end
