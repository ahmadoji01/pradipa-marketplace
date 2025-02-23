module ApplicationHelper
    include Pagy::Frontend

    def asset_exists?(path)
        if Rails.configuration.assets.compile
            Rails.application.precompiled_assets.include? path
        else
            Rails.application.assets_manifest.assets[path].present?
        end
    end

    def mobile_device?
        result = request.user_agent =~ /Mobile|webOS/
        if result.nil?
            return false
        end
        return true
    end
end
