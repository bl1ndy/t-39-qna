# frozen_string_literal: true

class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_question, only: %i[show update destroy]

  def index
    @questions = Question.all
  end

  def new
    @question = current_user.questions.build
  end

  def create
    @question = current_user.questions.build(question_params)

    if @question.save
      redirect_to @question, notice: 'Your Question successfully created!'
    else
      render :new
    end
  end

  def show
    @best_answer = @question.best_answer
    @answers = @question.answers.where.not(id: @best_answer&.id)
    @answer = @question.answers.build
  end

  def update
    if current_user == @question.user
      @question.update(question_params)
    else
      head :forbidden
    end
  end

  def destroy
    if current_user == @question.user
      @question.destroy

      redirect_to questions_path, notice: 'Your Question successfully deleted!'
    else
      head :forbidden
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :body, files: [])
  end

  def set_question
    @question = Question.with_attached_files.find(params[:id])
  end
end
