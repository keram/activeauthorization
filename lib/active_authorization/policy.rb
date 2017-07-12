# frozen_string_literal: true

# policy = Policy.new(current_user)
# policy.authorize(article, 'create')

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
          raise PolicyAccessDenied.new(seeker: seeker,
                                       receiver: receiver,
                                       message_name: message_name)
        }
      }[authorized?(receiver: receiver, message_name: message_name)].call
    end

    def authorize(receiver:, message_name:)
      {
        true => yield,
        false => nil
      }[authorized?(receiver: receiver, message_name: message_name)]
    end

    private

    attr_reader :factory, :seeker

    def authorization_roles(*)
      raise NotImplemented,
            'The method `authorization_roles` needs to be implemented in ' +
            self.class.name
    end

    def authorizations(receiver)
      authorization_roles(seeker: seeker).lazy.map do |role|
        factory
          .build(seeker: seeker, receiver: receiver, role: role)
      end
    end
  end
end
