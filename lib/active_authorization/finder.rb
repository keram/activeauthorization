# frozen_string_literal: true

module ActiveAuthorization
  class Finder
    FALLBACK = Authorization
    AUTH_MOD_PREFIX = 'Authorizations::'
    MOD_SEPARATOR = '::'
    TOP_LEVEL_RE = /\A(\w+\:\:)?Authorizations\:\:\w+Authorization\z/

    class << self
      def search_scope(ancestors)
        namespaced_authorizations(
          namespace_combinations(ancestors.map(&:name))
        ) | top_level_authorizations
      end

      private

      def namespace_combinations(ancestors_names)
        ancestors_names.flat_map do |anc_name|
          namespace_words_combinations(anc_name.split(MOD_SEPARATOR))
        end
      end

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
    end

    def initialize(receiver_class)
      @search_scope =
        self.class.search_scope(
          ActiveAuthorization.class_ancestors(receiver_class)
        )
    end

    def find(class_name)
      select(class_name).push(FALLBACK).first
    end

    def select(class_name)
      @search_scope.select { |cls| cls.name.include?(class_name) }
    end
  end
end
