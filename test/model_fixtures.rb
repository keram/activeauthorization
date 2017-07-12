# frozen_string_literal: true

class AuthorizableObject
  include ActiveAuthorization::Authorizable

  def self.authorization_roles(seeker:)
    seeker.roles
  end

  def authorization_roles(seeker:)
    self.class.authorization_roles(seeker: seeker)
  end
end

class AuthorizableSubObject < AuthorizableObject
end

class NoAuthorizationRolesObject
  include ActiveAuthorization::Authorizable
end

module Some
  module Nested
    class ExtendedObject
      include ActiveAuthorization::Authorizable

      def self.authorization_roles(seeker:)
        seeker.roles
      end
    end
  end
end
