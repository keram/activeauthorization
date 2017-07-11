# frozen_string_literal: true

module ActiveAuthorization
  module Concern
    module ClassMethods
      def authorized?(seeker:, message_name:)
        authorization_roles(seeker).any? do |role|
          Factory.new(Finder.new(self))
                 .build(seeker: seeker, receiver: self, role: role)
                 .authorized?(message_name)
        end
      end

      def authorize!(seeker:, message_name:)
        {
          true => -> { true },
          false => lambda {
            raise ConcernAccessDenied.new(seeker: seeker,
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

      private

      def authorization_roles(*)
        raise NotImplemented,
              'The method `authorization_roles` needs to be implemented in ' +
              name
      end
    end
  end
end
