# frozen_string_literal: true

class Api::V1::BaseController < ApplicationController
  before_action :doorkeeper_authorize!

  private

  def current_resource_owner
    @current_resource_owner ||= User.find(doorkeeper_token&.resource_owner_id)
  end

  def pundit_user
    current_resource_owner
  end
end
