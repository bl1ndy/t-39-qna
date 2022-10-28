# frozen_string_literal: true

class SearchController < ApplicationController
  def index
    @results = SearchService.new(params[:q], params[:scope]).call
  end
end
