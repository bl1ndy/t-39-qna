# frozen_string_literal: true

class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates :title, :url, presence: true
  validates :url, url: true

  def gist?
    URI.parse(url).host == 'gist.github.com'
  end
end
