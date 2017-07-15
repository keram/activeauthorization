# frozen_string_literal: true

module ActiveAuthorization
  class Policy
    def initialize(seeker:, factory:)
      @seeker = seeker
      @factory = factory
    end

    def authorized?(receiver:, message_name:)
      authorizations(receiver).any? { |auth| auth.authorized?(message_name) }
    end

    def authorize!(receiver:, message_name:)
      {
        true => -> { true },
        false => lambda {
          raise AccessDenied.new(seeker: seeker,
                                 receiver: receiver,
                                 message_name: message_name,
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

    attr_reader :factory, :seeker

    def authorization_roles(*)
      raise NotImplemented,
            'The method `authorization_roles(seeker:)` not implemented.'
    end

    def authorizations(receiver)
      authorization_roles(seeker: seeker).lazy.map do |role|
        factory
          .build(seeker: seeker, receiver: receiver, role: role)
      end
    end
  end
end
