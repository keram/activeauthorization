# frozen_string_literal: true

module Authorizations
  class ManagerAuthorization < ActiveAuthorization::Authorization
    def can_make_a_tea?
      true
    end
  end
end
