# frozen_string_literal: true

class QuestionPolicy < ApplicationPolicy
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

  private

  def author?
    user == record.user
  end
end
