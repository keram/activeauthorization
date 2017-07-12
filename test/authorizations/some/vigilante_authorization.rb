# frozen_string_literal: true

module Authorizations
  module Some
    class VigilanteAuthorization < ActiveAuthorization::Authorization
      def can_make_a_tea?
        false
      end

      def can_swear?
        true
      end
    end
  end
end
