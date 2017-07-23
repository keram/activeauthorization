# frozen_string_literal: true

module ActiveAuthorization
  class Finder
    FALLBACK = -> { Authorization }
    MOD_SEPARATOR = '::'

    class << self
      def search_scope(klass)
        namespace_combinations(class_ancestors(klass))
          .push([]).flat_map { |words| ActiveAuthorization.tree[words] }
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
      # => [['Alfa', 'Beta', 'Gamma', 'Delta'],
      #     ['Alfa', 'Beta', 'Gamma'],
      #     ['Alfa', 'Beta'],
      #     ['Alfa']]
      def namespace_words_combinations(words)
        [].tap do |ary|
          words.length.times do |wi|
            ary.push(words.slice(0..(-1 * (wi + 1))))
          end
        end
      end

      def class_ancestors(klass)
        klass
          .ancestors
          .select { |ancestor| ancestor.is_a? Class }
          .reject { |ancestor| [Object, BasicObject].include? ancestor }
      end
    end

    def initialize(klass)
      @search_scope = self.class.search_scope(klass)
    end

    def find(authorization_class_name)
      @search_scope.detect(FALLBACK) do |klass|
        klass.name.include?(authorization_class_name)
      end
    end
  end
end
