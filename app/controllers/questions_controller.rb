# frozen_string_literal: true

class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: %i[index show]
  before_action :set_question, except: %i[index new create]

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
    @subscription = @question.subscriptions.find_by(user: current_user)
    @best_answer = @question.best_answer
    @answers = @question.answers.with_attached_files.where.not(id: @best_answer&.id)
    @answer = @question.answers.build
    @answer.links.build
    @question_comment = @question.comments.build
    @answer_comment = @answer.comments.build
  end
  # rubocop:enable Metrics/AbcSize

  def update
    authorize @question

    @question.update(question_params)
  end

  def destroy
    authorize @question

    @question.destroy
    flash[:success] = 'Your Question successfully deleted!'

    redirect_to questions_path
  end

  def destroy_file
    authorize @question

    @file = ActiveStorage::Attachment.find(params[:file_id])
    @file.purge
  end

  def destroy_link
    authorize @question

    @link = Link.find(params[:link_id])
    @link.destroy
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
