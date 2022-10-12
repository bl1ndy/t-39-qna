# frozen_string_literal: true

class AnswerPolicy < ApplicationPolicy
  class Scope < Scope
  end

  def update?
    author?
  end

  def destroy?
    author?
  end

  def destroy_file?
    author?
  end

  def destroy_link?
    author?
  end

  def best?
    user == record.question.user
  end

  private

  def author?
    user == record.user
  end
end
