class ApplicationController < ActionController::Base
  before_action :coming_soon
  add_flash_types :success, :warning, :info, :danger
  include Pagy::Backend

  def coming_soon
    if ENV["RAILS_COMING_SOON"] == "true"
      redirect_to root_path
    end
  end
end
