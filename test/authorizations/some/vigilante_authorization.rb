# frozen_string_literal: true

module ActiveAuthorization
  module Authorizations
    module Some
      class VigilanteAuthorization < Authorization
        def can_make_a_tea?
          false
        end

        def can_swear?
          true
        end
      end
    end
  end
end
