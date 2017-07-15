# frozen_string_literal: true

module Authorizations
  module Some
    module Nested
      module AuthorizableObject
        class GuestAuthorization < ActiveAuthorization::Authorization
          def make_a_tea?
            false
          end
        end

        class CustomerAuthorization < ActiveAuthorization::Authorization
          def make_a_tea?
            true
          end
        end

        class ModeratortAuthorization < ActiveAuthorization::Authorization
          def make_a_tea?
            true
          end
        end
      end
    end
  end
end
