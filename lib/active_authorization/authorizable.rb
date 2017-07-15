# frozen_string_literal: true

module ActiveAuthorization
  # The main module to be used by including it in the class
  # that needs implement authorization on messages it receives.
  #
  # == Usage:
  #
  # Lets have classes
  #
  #    class Resource
  #      include ActiveAuthorization::Authorizable
  #
  #      def authorization_roles(seeker:)
  #        seeker.roles
  #      end
  #
  #      def create
  #      end
  #    end
  #
  #    class User
  #      def roles
  #        ['Admin']
  #      end
  #    end
  #
  #    class AdminAuthorization < ActiveAuthorization::Authorization
  #      def create?
  #        true
  #      end
  #    end
  #
  # their instances
  #
  #    resource = Resource.new
  #    user = User.new
  #
  # then we can send different authorization related messages to the resource
  #
  #    resource.authorize!(seeker: user, message_name: 'create')  # => true
  #    resource.authorized?(seeker: user, message_name: 'create') # => true
  #    resource.authorized(seeker: user, message_name: 'create') do
  #      resource.create
  #    end # => execute the block passed in
  #
  module Authorizable
    def self.included(klass)
      klass.extend Authorizable

      klass.class_eval do
        protected

        def authorization_factory
          self.class.authorization_factory
        end
      end
    end
    private_class_method :included

    # == Usage
    #
    #   resource.authorized? seeker: curren_user, message_name: 'update'
    #
    # @param seeker [?] the entity requesting message to be send.
    # @param message_name [String] The message to be send to the receiver
    # @return [Boolean] true or false based on the roles the seeker have
    #         and the corresponding Authorizations.
    #         When seeker have multiple roles eg authorizations, the method
    #         returns true if any of the authorizations return true.
    def authorized?(seeker:, message_name:)
      authorization_roles(seeker: seeker).any? do |role|
        authorization_factory
          .build(seeker: seeker, receiver: self, role: role)
          .authorized?(message_name)
      end
    end

    # == Usage
    #
    #   resource.authorize! seeker: curren_user, message_name: 'update'
    #
    # @param seeker [?] the entity requesting message to be send.
    # @param message_name [String] The message to be send to the receiver
    # @return [true, StandardError]
    #         true or raise ActiveAuthorization::AuthorizableAccessDenied
    #         exception
    def authorize!(seeker:, message_name:)
      {
        true => -> { true },
        false => lambda {
          raise AccessDenied.new(seeker: seeker,
                                 receiver: self,
                                 message_name: message_name,
                                 type: :authorizable)
        }
      }[authorized?(seeker: seeker, message_name: message_name)].call
    end

    # == Usage
    #
    #    resource.authorized(seeker: user, message_name: 'create') do
    #      resource.create
    #    end
    #
    # @param seeker [?] the entity requesting message to be send.
    # @param message_name [String] The message to be send to the receiver
    # @param block [Proc]
    # @return [nil, *] nil or content of the block passed in
    def authorize(seeker:, message_name:)
      {
        true => -> { yield },
        false => -> {}
      }[authorized?(seeker: seeker, message_name: message_name)].call
    end

    protected

    def authorization_roles(*)
      raise NotImplemented,
            'The method `authorization_roles(seeker:)` not implemented.'
    end

    def authorization_factory
      Factory.new(Finder.new(self))
    end
  end
end
