# frozen_string_literal: true

module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: %i[vote_up vote_down cancel_vote]
  end

  def vote_up
    vote(1)
  end

  def vote_down
    vote(-1)
  end

  def cancel_vote
    @votable.votes.find_by(user: current_user)&.destroy

    render json: @votable.rating
  end

  private

  def vote(rate)
    vote = @votable.votes.build(rate:, user: current_user)

    if vote.save
      render json: @votable.rating
    else
      render json: vote.errors.messages.values.flatten, status: :unprocessable_entity
    end
  end

  def set_votable
    @votable = model_klass.find(params[:id])
  end

  def model_klass
    controller_name.classify.constantize
  end
end
