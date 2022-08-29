# frozen_string_literal: true

class Answer < ApplicationRecord
  include Linkable

  belongs_to :user
  belongs_to :question

  has_many_attached :files

  validates :body, presence: true
end
