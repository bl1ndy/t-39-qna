# frozen_string_literal: true

class Api::V1::ProfilesController < Api::V1::BaseController
  def index
    render json: User.where.not(id: current_resource_owner.id)
  end

  def me
    render json: current_resource_owner
  end
end
