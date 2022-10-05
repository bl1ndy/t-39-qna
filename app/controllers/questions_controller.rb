# frozen_string_literal: true

class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: %i[index show]
  before_action :set_question, only: %i[show update destroy destroy_file destroy_link]

  def index
    @questions = Question.all
  end

  def new
    @question = current_user.questions.build
    @question.links.build
    @question.build_reward
  end

  def create
    @question = current_user.questions.build(question_params)

    if @question.save
      flash[:success] = 'Your Question successfully created!'
      publish_question

      redirect_to @question
    else
      render :new
    end
  end

  # rubocop:disable Metrics/AbcSize
  def show
    @user_vote = @question.votes.find_by(user: current_user)
    @best_answer = @question.best_answer
    @answers = @question.answers.with_attached_files.where.not(id: @best_answer&.id)
    @answer = @question.answers.build
    @answer.links.build
    @question_comment = @question.comments.build
    @answer_comment = @answer.comments.build
  end
  # rubocop:enable Metrics/AbcSize

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

  def destroy_link
    @link = Link.find(params[:link_id])

    if current_user == @question.user
      @link.destroy
    else
      head :forbidden
    end
  end

  private

  def publish_question
    html = ApplicationController.render(
      partial: 'questions/question',
      locals: { question: @question }
    )

    ActionCable.server.broadcast('questions', html)
  end

  def question_params
    params.require(:question).permit(
      :title,
      :body,
      files: [],
      links_attributes: %i[id title url],
      reward_attributes: %i[title image_url]
    )
  end

  def set_question
    @question = Question.with_attached_files.find(params[:id])
  end
end
