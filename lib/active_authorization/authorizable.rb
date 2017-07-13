# frozen_string_literal: true

module ActiveAuthorization
  module Authorizable
    def self.included(klass)
      klass.extend Authorizable

      klass.class_eval do
        def authorization_factory
          self.class.authorization_factory
        end
      end
    end

    def authorized?(seeker:, message_name:)
      authorization_roles(seeker: seeker).any? do |role|
        authorization_factory
          .build(seeker: seeker, receiver: self, role: role)
          .authorized?(message_name)
      end
    end

    def authorize!(seeker:, message_name:)
      {
        true => -> { true },
        false => lambda {
          raise AuthorizableAccessDenied.new(seeker: seeker,
                                             receiver: self,
                                             message_name: message_name)
        }
      }[authorized?(seeker: seeker, message_name: message_name)].call
    end

    def authorize(seeker:, message_name:)
      {
        true => yield,
        false => nil
      }[authorized?(seeker: seeker, message_name: message_name)]
    end

    def authorization_roles(*)
      raise NotImplemented,
            'The method `authorization_roles(seeker:)` not implemented.'
    end

    def authorization_factory
      Factory.new(Finder.new(self))
    end
  end
end
