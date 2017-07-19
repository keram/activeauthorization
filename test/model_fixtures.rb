# frozen_string_literal: true

class AuthorizableObject
  include ActiveAuthorization::Authorizable

  def self.authorization_roles(user:)
    user.roles
  end

  def authorization_roles(user:)
    self.class.authorization_roles(user: user)
  end
end

class AuthorizableSubObject < AuthorizableObject
end

class NoAuthorizationRolesObject
  include ActiveAuthorization::Authorizable
end

module Some
  module Nested
    class AuthorizableObject
      include ActiveAuthorization::Authorizable

      def self.authorization_roles(user:)
        user.roles
      end
    end
  end
end
