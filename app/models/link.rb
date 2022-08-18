# frozen_string_literal: true

class Link < ApplicationRecord
  belongs_to :question

  validates :title, :url, presence: true
end
