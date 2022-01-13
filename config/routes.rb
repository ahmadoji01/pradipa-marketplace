Rails.application.routes.draw do

  resources :mailings
  match '/404', via: :all, to: 'errors#not_found'
  match '/422', via: :all, to: 'errors#unprocessable_entity'
  match '/500', via: :all, to: 'errors#server_error'

  scope module: 'spree' do
    resources :blogs

    get '/post/:slug', :to => 'blogs#show_post', :as => 'post_page'

    get '/brand/:slug', :to => 'home#brand', :as => 'brand_page'

    get '/about-us', :to => 'static_pages#about', :as => 'about_us_page'
    get '/terms-and-conditions', :to => 'static_pages#terms_and_conditions', :as => 'terms_and_conditions_page'
    get '/privacy-policy', :to => 'static_pages#privacy_policy', :as => 'privacy_policy_page'
    get '/return-policy', :to => 'static_pages#return_policy', :as => 'return_policy_page'
    get '/faq', :to => 'static_pages#faq', :as => 'faq_page'
    get '/order-status', :to => 'static_pages#order_status', :as => 'order_status_page'
    get '/how-to-order', :to => 'static_pages#how_to_order', :as => 'how_to_order_page'
    get '/track-my-package', :to => 'static_pages#track_my_package', :as => 'track_my_package_page'
    get '/contact-us', :to => 'static_pages#contact_us', :as => 'contact_us_page'
    get '/coming-soon', :to => 'static_pages#coming_soon', :as => 'coming_soon_page'

    post '/submit_ticket', :to => 'static_pages#submit_ticket'
    post '/submit_mailing', :to => 'mailings#submit_mailing'

    get '/producer_dashboard', :to => 'producer_dashboard#redirect_to_home'
    get '/producer_dashboard/home', :to => 'producer_dashboard#index', :as => 'producer_dashboard_home_page'
    get '/producer_dashboard/brand_info', :to => 'producer_dashboard#brand_info', :as => 'producer_dashboard_brand_info_page'
    get '/producer_dashboard/orders', :to => 'producer_dashboard#orders', :as => 'producer_dashboard_orders_page'
    get '/producer_dashboard/products', :to => 'producer_dashboard#products', :as => 'producer_dashboard_products_page'
    get '/producer_dashboard/payment_info', :to => 'producer_dashboard#payment_info', :as => 'producer_dashboard_payment_info_page'
    get '/producer_dashboard/support', :to => 'producer_dashboard#support', :as => 'producer_dashboard_support_page'
    get '/producer_dashboard/withdrawals', :to => 'producer_dashboard#withdrawals', :as => 'producer_dashboard_withdrawals_page'
    get '/producer_dashboard/request_withdrawal', :to => 'producer_dashboard#request_withdrawal', :as => 'producer_dashboard_request_withdrawal_page'
    get '/producer_dashboard/shipping_requests', :to => 'producer_dashboard#shipping_requests', :as => 'producer_dashboard_shipping_requests_page'
    get '/producer_dashboard/shipping_request/:id', :to => 'producer_dashboard#show_shipping_request', :as => 'producer_dashboard_shipping_request_page'
    get '/producer_dashboard/notifications', :to => 'producer_dashboard#notifications', :as => 'producer_dashboard_notifications_page'

    put '/producer_dashboard/update_payment_info', :to => 'producer_dashboard#update_payment_info'
    post '/producer_dashboard/create_wd_request', :to => 'producer_dashboard#create_wd_request'
    post '/producer_dashboard/submit_ticket', :to => 'producer_dashboard#submit_ticket'
    post '/producer_dashboard/submit_brand_info', :to => 'producer_dashboard#submit_brand_info'
    post '/producer_dashboard/submit_contact_info', :to => 'producer_dashboard#submit_contact_info'
    put '/producer_dashboard/update_notif', :to => 'producer_dashboard#update_notif'
    patch '/producer_dashboard/update_notif_read_status', :to => 'producer_dashboard#update_notif_read_status'

    namespace :admin do
      resources :withdrawals
      resources :withdrawal_requests
      resources :withdrawal_balances
      resources :tickets
      resources :blogs
      resources :blog_categories
    end
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
