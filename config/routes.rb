Rails.application.routes.draw do
  scope module: 'spree' do
    resources :blogs
    get '/about-us', :to => 'static_pages#about', :as => 'about_us_page'
    get '/terms-and-conditions', :to => 'static_pages#terms_and_conditions', :as => 'terms_and_conditions_page'
    get '/privacy-policy', :to => 'static_pages#privacy_policy', :as => 'privacy_policy_page'
    get '/return-policy', :to => 'static_pages#return_policy', :as => 'return_policy_page'
    get '/faq', :to => 'static_pages#faq', :as => 'faq_page'
    get '/order-status', :to => 'static_pages#order_status', :as => 'order_status_page'
    get '/track-my-package', :to => 'static_pages#track_my_package', :as => 'track_my_package_page'
    get '/contact-us', :to => 'static_pages#contact_us', :as => 'contact_us_page'
  end
  # This line mounts Solidus's routes at the root of your application.
  # This means, any requests to URLs such as /products, will go to Spree::ProductsController.
  # If you would like to change where this engine is mounted, simply change the :at option to something different.
  #
  # We ask that you don't use the :as option here, as Solidus relies on it being the default of "spree"
  mount Spree::Core::Engine, at: '/'

mount SolidusPaypalCommercePlatform::Engine, at: '/solidus_paypal_commerce_platform'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
