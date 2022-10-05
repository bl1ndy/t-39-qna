# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @comment = commentable.comments.create(comment_params.merge(user: current_user))
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def commentable
    commentables = [Question, Answer]
    commentable_class = commentables.find { |klass| params["#{klass.name.underscore}_id"] }
    @commentable = commentable_class.find(params["#{commentable_class.name.underscore}_id"])
  end
end
