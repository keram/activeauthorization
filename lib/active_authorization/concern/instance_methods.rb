# frozen_string_literal: true

module ActiveAuthorization
  module Concern
    module InstanceMethods
      include ClassMethods

      private

      def authorization_roles(*)
        raise NotImplemented,
              'The method `authorization_roles` needs to be implemented in ' +
              self.class.name
      end

      def authorization_finder
        Finder.new(self.class)
      end
    end
  end
end
