# frozen_string_literal: true

class Api::V1::QuestionsController < Api::V1::BaseController
  def index
    questions = Question.all

    render json: questions
  end

  def show
    render json: question
  end

  def create
    question = current_resource_owner.questions.build(question_params)

    if question.save
      render json: question, status: :created
    else
      render json: { errors: question.errors }, status: :unprocessable_entity
    end
  end

  def update
    authorize question

    if question.update(question_params)
      render json: question, status: :created
    else
      render json: { errors: question.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    authorize question

    if question.destroy
      render json: question, status: :ok
    else
      render json: { errors: 'An error occurred while destroying Question' }, status: :unprocessable_entity
    end
  end

  private

  def question_params
    params.require(:question).permit(
      :title,
      :body,
      links_attributes: %i[id title url],
      reward_attributes: %i[title image_url]
    )
  end

  def question
    @question ||= Question.find(params[:id])
  end
end
