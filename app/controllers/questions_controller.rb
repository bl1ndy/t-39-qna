# frozen_string_literal: true

class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show] # rubocop:disable Rails/LexicallyScopedActionFilter

  expose :questions, -> { Question.all }
  expose :question, :set_question
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

    redirect_to questions_path, notice: 'Your Question successfully deleted!'
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end

  def set_question
    if params[:id]
      Question.find_by(id: params[:id])
    elsif params[:question]
      current_user.questions.build(question_params)
    else
      current_user.questions.build
    end
  end
end
