# frozen_string_literal: true

module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: %i[vote_up vote_down]
    before_action :check_author_vote, only: %i[vote_up vote_down]
  end

  def vote_up
    vote(1)
  end

  def vote_down
    vote(-1)
  end

  private

  def vote(rate)
    vote = @votable.votes.build(rate:, user: current_user)

    respond_to do |format|
      if vote.save
        format.json { render json: vote }
      else
        format.json { render json: vote.errors }
      end
    end
  end

  def set_votable
    @votable = model_klass.find(params[:id])
  end

  def check_author_vote
    return unless current_user == @votable.user

    json = {
      errors: {
        access: "You can't vote for your own post"
      }
    }

    respond_to do |format|
      format.json { render json: }
    end
  end

  def model_klass
    controller_name.classify.constantize
  end
end
