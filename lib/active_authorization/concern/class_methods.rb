# frozen_string_literal: true

module ActiveAuthorization
  module Concern
    module ClassMethods
      def authorized?(seeker:, message_name:)
        authorization_instances_for(seeker)
          .any? { |authorization| authorization.authorized?(message_name) }
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

      def authorization_instances_for(seeker)
        authorization_roles(seeker).lazy.map do |role|
          authorization_instance_factory.build(seeker: seeker,
                                               receiver: self,
                                               role: role)
        end
      end

      def authorization_instance_factory
        Factory.new(authorization_finder)
      end

      def authorization_finder
        Finder.new(self)
      end
    end
  end
end
