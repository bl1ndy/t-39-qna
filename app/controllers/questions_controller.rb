# frozen_string_literal: true

class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show] # rubocop:disable Rails/LexicallyScopedActionFilter

  expose :questions, -> { Question.all }
  expose :question
  expose :answers, from: :question
  expose :answer, -> { question.answers.build }

  def create
    if question.save
      redirect_to question, notice: 'Your Question successfully created!'
    else
      render :new
    end
  end

  def update
    if question.update(question_params)
      redirect_to question
    else
      render :edit
    end
  end

  def destroy
    question.destroy

    redirect_to questions_path
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
