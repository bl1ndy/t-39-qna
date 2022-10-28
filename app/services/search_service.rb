# frozen_string_literal: true

class SearchService
  def initialize(query, scope)
    @query = ThinkingSphinx::Query.escape(query)
    @scope = scope == 'All' ? ThinkingSphinx : scope.constantize
  end

  def call
    @query.empty? ? [] : @scope.search(@query, order: 'created_at DESC')
  end
end
