# frozen_string_literal: true

class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_question, only: %i[show update destroy destroy_file]

  def index
    @questions = Question.all
  end

  def new
    @question = current_user.questions.build
    @question.links.build
  end

  def create
    @question = current_user.questions.build(question_params)

    if @question.save
      flash[:success] = 'Your Question successfully created!'

      redirect_to @question
    else
      render :new
    end
  end

  def show
    @best_answer = @question.best_answer
    @answers = @question.answers.with_attached_files.where.not(id: @best_answer&.id)
    @answer = @question.answers.build
    @answer.links.build
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
      flash[:success] = 'Your Question successfully deleted!'

      redirect_to questions_path
    else
      head :forbidden
    end
  end

  def destroy_file
    @file = ActiveStorage::Attachment.find(params[:file_id])

    if current_user == @question.user
      @file.purge
    else
      head :forbidden
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :body, files: [], links_attributes: %i[title url])
  end

  def set_question
    @question = Question.with_attached_files.find(params[:id])
  end
end
