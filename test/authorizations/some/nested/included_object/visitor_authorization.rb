# frozen_string_literal: true

module ActiveAuthorization
  module Authorizations
    module Some
      module Nested
        module IncludedObject
          class VisitorAuthorization < Authorization
            def can_make_a_tea?
              false
            end
          end
        end
      end
    end
  end
end
