# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pundit::Authorization

  rescue_from(Pundit::NotAuthorizedError) { head :forbidden }
end
