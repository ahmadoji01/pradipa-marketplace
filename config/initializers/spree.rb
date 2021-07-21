# Configure Solidus Preferences
# See http://docs.solidus.io/Spree/AppConfiguration.html for details

Spree.config do |config|
  # Core:

  # Default currency for new sites
  config.currency = "USD"

  # from address for transactional emails
  config.mails_from = "store@example.com"

  # Uncomment to stop tracking inventory levels in the application
  # config.track_inventory_levels = false

  # When set, product caches are only invalidated when they fall below or rise
  # above the inventory_cache_threshold that is set. Default is to invalidate cache on
  # any inventory changes.
  # config.inventory_cache_threshold = 3

  # Configure adapter for attachments on products and taxons (use ActiveStorageAttachment or PaperclipAttachment)
  config.image_attachment_module = 'Spree::Image::ActiveStorageAttachment'
  config.taxon_attachment_module = 'Spree::Taxon::ActiveStorageAttachment'

  # Defaults
  # Permission Sets:

  # Uncomment and customize the following line to add custom permission sets
  # to a custom users role:
  config.roles.assign_permissions :blogger, ['Spree::PermissionSets::Blogger']
  config.roles.assign_permissions :producer, ['Spree::PermissionSets::Producer']


  # Frontend:

  # Custom logo for the frontend
  # config.logo = "logo/solidus.svg"

  # Template to use when rendering layout
  # config.layout = "spree/layouts/spree_application"


  # Admin:

  # Custom logo for the admin
  # config.admin_interface_logo = "logo/solidus.svg"

  # Gateway credentials can be configured statically here and referenced from
  # the admin. They can also be fully configured from the admin.
  #
  # Please note that you need to use the solidus_stripe gem to have
  # Stripe working: https://github.com/solidusio-contrib/solidus_stripe
  #
  # config.static_model_preferences.add(
  #   Spree::PaymentMethod::StripeCreditCard,
  #   'stripe_env_credentials',
  #   secret_key: ENV['STRIPE_SECRET_KEY'],
  #   publishable_key: ENV['STRIPE_PUBLISHABLE_KEY'],
  #   server: Rails.env.production? ? 'production' : 'test',
  #   test_mode: !Rails.env.production?
  # )
  config.static_model_preferences.add(
    SolidusPaypalCommercePlatform::PaymentMethod,
    'paypal_commerce_platform_credentials', {
      test_mode: !Rails.env.production?,
      client_id: 'AfJCNhRRzIyhUilcdgslV8Idj_gV_mxdyljERyLfEosAChscDqHgYalr7TrUJ2Es7BkAUgPrZ5mOceGE',
      client_secret: 'ELQMCJbgPma6VjvDbbIaeUUMrjhZAA3d5_XhVV6DSmxY-Z5ZkMd03vQQsQHUe1WeXh3HOA0jnPjOeS9z',
      display_on_product_page: true,
      display_on_cart: true,
    }
  )
end

Spree::PermittedAttributes.product_attributes << :user_id

Spree::Frontend::Config.configure do |config|
  config.locale = 'en'
end

Spree::Backend::Config.configure do |config|
  config.locale = 'en'

  # Uncomment and change the following configuration if you want to add
  # a new menu item:
  #
  # config.menu_items << config.class::MenuItem.new(
  #   [:section],
  #   'icon-name',
  #   url: 'https://solidus.io/'
  # )

  config.menu_items << config.class::MenuItem.new(
    [:blog],
    'dollar',
    url: '/admin/blogs'
  )

  config.menu_items << config.class::MenuItem.new(
    [:ticket],
    'dollar',
    url: '/admin/tickets'
  )

  config.menu_items << config.class::MenuItem.new(
    [:withdrawal],
    'dollar',
    url: '/admin/withdrawals'
  )

  config.menu_items << config.class::MenuItem.new(
    [:withdrawal_request],
    'dollar',
    url: '/admin/withdrawal_requests'
  )
end

Spree::Api::Config.configure do |config|
  config.requires_authentication = true
end

Spree.user_class = "Spree::LegacyUser"

# Rules for avoiding to store the current path into session for redirects
# When at least one rule is matched, the request path will not be stored
# in session.
# You can add your custom rules by uncommenting this line and changing
# the class name:
#
# Spree::UserLastUrlStorer.rules << 'Spree::UserLastUrlStorer::Rules::AuthenticationRule'
