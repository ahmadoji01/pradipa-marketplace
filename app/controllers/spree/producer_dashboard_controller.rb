module Spree
  class ProducerDashboardController < Spree::StoreController

    layout 'spree/layouts/producer_dashboard'

    def index
      @line_items = Spree::LineItem.joins(:product).where(:product => {:user_id => 1})
    end

    def orders
    end

    def products
    end

    def payment_info
    end

    def withdrawals
    end

    def support
    end

    def request_withdrawal
    end

    private

  end
end
