# frozen_string_literal: true

class Api::V1::ProfilesController < ApplicationController
  before_action :doorkeeper_authorize!

  def me
    render json: current_resource_owner
  end

  private

  def current_resource_owner
    @current_resource_owner ||= User.find(doorkeeper_token&.resource_owner_id)
  end
end
