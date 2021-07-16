module Spree
  class ProducerDashboardController < Spree::StoreController

    before_action :init_withdrawal, only: :index
    layout 'spree/layouts/producer_dashboard'

    def index
      @line_items = Spree::LineItem.joins(:product).where(:product => {:user_id => 1}).last(5)
      @shipped_items = count_shipped_items(@line_items)
      @info = Spree::Withdrawal.where(:user_id => 1)
      @wd_requests = Spree::WithdrawalRequest.joins(:withdrawal).where(:withdrawal => {:user_id => 1}).last(5)

      withdrawn_balance(@wd_requests)
      @available_balance = @balance - @wd_balance
    end

    def orders
      @line_items = Spree::LineItem.joins(:product).where(:product => {:user_id => 1})
    end

    def products
      @products = Spree::Product.where(:user_id => 1)
    end

    def payment_info
      @info = Spree::Withdrawal.where(:user_id => 1)
    end

    def withdrawals
      @wd_requests = Spree::WithdrawalRequest.where(:user_id => 1)
    end

    def request_withdrawal
    end

    def support
    end

    private
      def init_withdrawal
        @balance = 0
        @wd_balance = 0
        @available_balance = 0
      end

      def count_shipped_items(line_items)
        results = []
        line_items.each do |line_item|
          if line_item.order.shipment_state == 'shipped'
            results.push(line_item)
            @balance += line_item.price * line_item.quantity
          end
        end

        return results
      end

      def withdrawn_balance(wd_requests)
        wd_requests.each do |request|
          if request.status == 'Completed' || request.status == 'Processing'
            @wd_balance += request.balance
          end
        end
      end
  end
end
