# frozen_string_literal: true

module Authorizations
  module Some
    class VigilanteAuthorization < ActiveAuthorization::Authorization
      def make_a_tea?
        false
      end

      def swear?
        true
      end
    end
  end
end
