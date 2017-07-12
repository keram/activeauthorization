# frozen_string_literal: true

module ActiveAuthorization
  class Finder
    FALLBACK = -> { Authorization }
    AUTH_MOD_PREFIX = 'Authorizations::'
    MOD_SEPARATOR = '::'
    TOP_LEVEL_RE = /\A(\w+\:\:)?Authorizations\:\:\w+Authorization\z/

    class << self
      def search_scope(cls)
        namespaced_authorizations(
          namespace_combinations(class_ancestors(cls))
        ) | top_level_authorizations
      end

      private

      def namespace_combinations(ancestors)
        ancestors.flat_map do |ancestor|
          namespace_words_combinations(ancestor.name.split(MOD_SEPARATOR))
        end
      end

      # Let's have array of words
      # words = ['Alfa', 'Beta', 'Gamma', 'Delta']
      # namespace_words_combinations(words)
      # returns array of strings:
      # => ['Alfa::Beta::Gamma::Delta',
      #     'Alfa::Beta::Gamma',
      #     'Alfa::Beta',
      #     'Alfa']
      def namespace_words_combinations(words)
        [].tap do |ary|
          words.length.times do |wi|
            ary.push(
              words.slice(0..(-1 * (wi + 1))).join(MOD_SEPARATOR)
            )
          end
        end
      end

      def namespaced_authorizations(namespace_combinations)
        namespace_combinations.flat_map do |path|
          pref_path = AUTH_MOD_PREFIX.dup.concat(path)
          Authorizations.list.select { |auth| auth.name.include?(pref_path) }
        end
      end

      def top_level_authorizations
        Authorizations.list.select do |auth|
          TOP_LEVEL_RE.match?(auth.name)
        end
      end

      def class_ancestors(cls)
        cls
          .ancestors
          .select { |ancestor| ancestor.is_a? Class }
          .reject { |ancestor| [Object, BasicObject].include? ancestor }
      end
    end

    def initialize(receiver_class)
      @search_scope = self.class.search_scope(receiver_class)
    end

    def find(class_name)
      @search_scope.detect(FALLBACK) { |cls| cls.name.include?(class_name) }
    end
  end
end
