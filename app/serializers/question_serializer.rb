# frozen_string_literal: true

class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :short_title, :body, :created_at, :updated_at

  belongs_to :user
  has_many :answers

  def short_title
    object.title.truncate(10)
  end
end
