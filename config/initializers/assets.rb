# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path
# Add Yarn node_modules folder to the asset load path.
Rails.application.config.assets.paths << Rails.root.join('node_modules')

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.
Rails.application.config.assets.precompile += %w(
    for_use/avatar/blank.png 

    main.js customFonts.css instafeed.min.js 

    producer_dashboard/off-canvas.js
    producer_dashboard/hoverable-collapse.js
    producer_dashboard/template.js
    producer_dashboard/settings.js
    producer_dashboard/todolist.js
    producer_dashboard/dashboard.js
    producer_dashboard/Chart.roundedBarCharts.js
    producer_dashboard/vendors/vendor.bundle.base.js
    producer-dashboard-style.css

    producer_dashboard/vendors/vendor.bundle.base.css
)
