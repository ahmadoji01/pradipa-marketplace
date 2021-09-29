class ApplicationController < ActionController::Base
  add_flash_types :success, :warning, :info, :danger
  include Pagy::Backend
end
