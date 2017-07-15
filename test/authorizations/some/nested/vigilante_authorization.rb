# frozen_string_literal: true

module Authorizations
  module Some
    module Nested
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
end
