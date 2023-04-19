# frozen_string_literal: true

# Default Controller
class ApplicationController < ActionController::Base
  before_action :authenticate_user!
end
