# frozen_string_literal: true

module ActiveAuthorization
  class Policy
    def initialize(user:, factory:)
      @user = user
      @factory = factory
    end

    def authorized?(receiver:, message_name:)
      authorizations(receiver).any? { |auth| auth.authorized?(message_name) }
    end

    def authorize!(receiver:, message_name:)
      {
        true => -> { true },
        false => lambda {
          raise AccessDenied.new(user: user,
                                 receiver: receiver,
                                 message_name: message_name,
                                 invoker: self,
                                 type: :policy)
        }
      }[authorized?(receiver: receiver, message_name: message_name)].call
    end

    def authorize(receiver:, message_name:, &block)
      {
        true => block,
        false => -> {}
      }[authorized?(receiver: receiver, message_name: message_name)].call
    end

    private

    attr_reader :factory, :user

    def authorization_roles(*)
      raise NotImplemented,
            'The method `authorization_roles(user:)` not implemented.' \
            "\n" \
            'Please define ' +
            self.class.name.concat('#authorization_roles(user:)') +
            ' method.'
    end

    def authorizations(receiver)
      authorization_roles(user: user).lazy.map do |role|
        factory
          .build(user: user, receiver: receiver, role: role)
      end
    end
  end
end
