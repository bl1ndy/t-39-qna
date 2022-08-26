# frozen_string_literal: true

class Reward < ApplicationRecord
  belongs_to :question
  belongs_to :user, optional: true

  validates :title, :image_url, presence: true
end
