class ApplicationController < ActionController::Base
  before_action :coming_soon
  add_flash_types :success, :warning, :info, :danger
  include Pagy::Backend

  def coming_soon
    if ENV["RAILS_COMING_SOON"] != "true"
      return
    end

    if request.path.include?("submit_mailing")
      return
    end

    if request.path.include?("admin")
      return
    end

    if request.path.include?("collection")
      return
    end

    if request.path.include?("blogs")
      return
    end

    if spree_current_user.nil?
      redirect_to main_app.coming_soon_page_path
      return
    end

    if spree_current_user.role_users.first.role.name != "admin"
      redirect_to main_app.coming_soon_page_path
      return
    end

    redirect_to main_app.coming_soon_page_path
    return

  end

  private
    def current_controller?(names)
      names.include?(controller_name)
    end

end
