module Spree
  class ProducerDashboardController < Spree::StoreController

    layout 'spree/layouts/producer_dashboard'
    helper_method :spree_current_user

    def index
    end

    def orders
    end

    def withdrawals
    end

    def request_withdrawal
    end

    def spree_current_user
      current_user
    end

  end
end
