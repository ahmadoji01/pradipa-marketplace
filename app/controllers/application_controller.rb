class ApplicationController < ActionController::Base
  before_action :coming_soon, :menu_taxon_id_search
  add_flash_types :success, :warning, :info, :danger
  include Pagy::Backend

  def menu_taxon_id_search
    fashion = Spree::Taxon.find_by(name: "Fashion")
    home_decor = Spree::Taxon.find_by(name: "Home Decor")
    gifts = Spree::Taxon.find_by(name: "Gifts")

    @fashion_link = "/products"
    @home_decor_link = "/products"
    @gifts_link = "/products"

    if !fashion.nil?
      @fashion_link = "/products?taxon=" + fashion.id
    end
    if !home_decor.nil?
      @home_decor_link = "/products?taxon=" + home_decor.id
    end
    if !gifts.nil?
      @gifts_link = "/products?taxon=" + gifts.id
    end
  end

  def coming_soon
    if ENV["RAILS_COMING_SOON"] == "true"
      if request.path.include?("submit_mailing")
        return
      end
  
      if request.path.include?("admin")
        if spree_current_user.nil?
          redirect_to main_app.coming_soon_page_path
          return
        end

        if spree_current_user.role_users.first.role.name != "admin"
          redirect_to main_app.coming_soon_page_path
          return
        end
        return
      end
  
      if request.path.include?("blogs")
        return
      end
      return
    end
    return
  end

  private
    def current_controller?(names)
      names.include?(controller_name)
    end

end
