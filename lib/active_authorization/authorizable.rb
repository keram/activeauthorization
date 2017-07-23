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
  #      def authorization_roles(user:)
  #        user.roles
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
  #    resource.authorize!(user: user, message_name: 'create')  # => true
  #    resource.authorized?(user: user, message_name: 'create') # => true
  #    resource.authorized(user: user, message_name: 'create') do
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
    #   resource.authorized? user: curren_user, message_name: 'update'
    #
    # @param user [?] the entity requesting message to be send.
    # @param message_name [String] The message to be send to the receiver
    # @return [Boolean] true or false based on the roles the user have
    #         and the corresponding Authorizations.
    #         When user have multiple roles eg authorizations, the method
    #         returns true if any of the authorizations return true.
    def authorized?(user:, message_name:)
      authorization_roles(user: user).any? do |role|
        authorization_factory
          .build(user: user, receiver: self, role: role)
          .authorized?(message_name)
      end
    end

    # == Usage
    #
    #   resource.authorize! user: curren_user, message_name: 'update'
    #
    # @param user [?] the entity requesting message to be send.
    # @param message_name [String] The message to be send to the receiver
    # @return [true, AccessDenied]
    #         true or raise ActiveAuthorization::AuthorizableAccessDenied
    #         exception
    def authorize!(user:, message_name:)
      {
        true => -> { true },
        false => lambda {
          raise AccessDenied.new(user: user,
                                 receiver: self,
                                 message_name: message_name,
                                 type: :authorizable)
        }
      }[authorized?(user: user, message_name: message_name)].call
    end

    # == Usage
    #
    #    resource.authorized(user: user, message_name: 'create') do
    #      resource.create
    #    end
    #
    # @param user [?] the entity requesting message to be send.
    # @param message_name [String] The message to be send to the receiver
    # @param block [Proc]
    # @return [nil, *] nil or content of the block passed in
    def authorize(user:, message_name:, &block)
      {
        true => block,
        false => -> {}
      }[authorized?(user: user, message_name: message_name)].call
    end

    protected

    def authorization_roles(*)
      raise NotImplemented,
            'The method `authorization_roles(user:)` not implemented.'
    end

    def authorization_factory
      Factory.new(Finder.new(self))
    end
  end
end
