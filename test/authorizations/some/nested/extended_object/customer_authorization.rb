# frozen_string_literal: true

module ActiveAuthorization
  module Authorizations
    module Some
      module Nested
        module ExtendedObject
          class CustomerAuthorization < Authorization
            def can_make_a_tea?
              true
            end
          end
        end
      end
    end
  end
end
