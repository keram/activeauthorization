# frozen_string_literal: true

class ExtendedObject
  extend ActiveAuthorization::Concern::ClassMethods

  def self.authorization_roles(seeker)
    seeker.roles
  end
end

class ExtendedWithoutCustomerRoleObject
  extend ActiveAuthorization::Concern::ClassMethods
end

module Some
  module Nested
    class ExtendedObject
      extend ActiveAuthorization::Concern::ClassMethods

      def self.authorization_roles(seeker)
        seeker.roles
      end
    end
  end
end

class IncludedObject
  include ActiveAuthorization::Concern::InstanceMethods

  def authorization_roles(seeker)
    seeker.roles
  end
end

class IncludedWithoutCustomerRoleObject
  include ActiveAuthorization::Concern::InstanceMethods
end

module Some
  module Nested
    class IncludedObject
      include ActiveAuthorization::Concern::InstanceMethods

      # :reek:UtilityFunction:
      def authorization_roles(seeker)
        seeker.roles
      end
    end
  end
end

class ConcernedObject
  include ActiveAuthorization::Concern

  def self.authorization_roles(seeker)
    seeker.roles
  end

  def authorization_roles(seeker)
    seeker.roles
  end
end

class ConcernedSubObject < ConcernedObject
end
