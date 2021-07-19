module Spree
  class ProducerDashboardController < Spree::StoreController

    before_action :init_withdrawal, only: [:index, :request_withdrawal]
    before_action :init_user
    before_action :authorize
    layout 'spree/layouts/producer_dashboard'

    def index
      @line_items = Spree::LineItem.joins(:product).where(:product => {:user_id => @user.id}).last(5)
      @shipped_items = count_shipped_items(@line_items)
      @info = Spree::Withdrawal.where(:user_id => @user.id)
      @wd_requests = Spree::WithdrawalRequest.joins(:withdrawal).where(:withdrawal => {:user_id => @user.id}).last(5)

      withdrawn_balance(@wd_requests)
      @available_balance = @balance - @wd_balance
    end

    def orders
      @line_items = Spree::LineItem.joins(:product).where(:product => {:user_id => @user.id})
    end

    def products
      @products = Spree::Product.where(:user_id => @user.id)
    end

    def payment_info
      @info = Spree::Withdrawal.where(:user_id => @user.id).first
      @account = spree_current_user
    end

    def update_payment_info

      @withdrawal = Spree::Withdrawal.find_by(user_id: @user.id)
      if @withdrawal.nil?
        @withdrawal = Spree::Withdrawal.new
        @withdrawal.user = @user
      end

      @withdrawal.assign_attributes(withdrawal_params)

      respond_to do |format|
        if @withdrawal.save
          format.html { redirect_to main_app.producer_dashboard_payment_info_page_path, notice: "Withdrawal was successfully updated." }
          format.json { render :show, status: :created, location: main_app.producer_dashboard_payment_info_page_path }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @withdrawal.errors, status: :unprocessable_entity }
        end
      end
    end

    def withdrawals
      @wd_requests = Spree::WithdrawalRequest.joins(:withdrawal).where(:withdrawal => {:user_id => @user.id})
    end

    def request_withdrawal
      @line_items = Spree::LineItem.joins(:product).where(:product => {:user_id => @user.id})
      @shipped_items = count_shipped_items(@line_items)
      @wd_requests = Spree::WithdrawalRequest.joins(:withdrawal).where(:withdrawal => {:user_id => @user.id}).last(5)
      @wd_request = Spree::WithdrawalRequest.new
      
      withdrawn_balance(@wd_requests)
      @available_balance = @balance - @wd_balance
    end

    def create_wd_request
      @request = Spree::WithdrawalRequest.new(wd_request_params)
      @withdrawal = Spree::Withdrawal.where(:user_id => @user.id).first

      if @withdrawal.nil?
        redirect_to main_app.producer_dashboard_payment_info_page_path
        return
      end

      @request.withdrawal = @withdrawal
      @request.status = 'Requested'
      
      respond_to do |format|
        if @request.save
          format.html { redirect_to main_app.producer_dashboard_request_withdrawal_page_path, notice: "Withdrawal request was successfully created." }
          format.json { render :show, status: :created, location: main_app.producer_dashboard_request_withdrawal_page_path }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @request.errors, status: :unprocessable_entity }
        end
      end
    end

    def support
    end

    private

      def withdrawal_params
        if params[:withdrawal] && !params[:withdrawal].empty?
          params.require(:withdrawal).permit(:id, :spree_user_id, :bank_name, :bank_number, :bank_swift_code, :bank_country, :full_name, :address)
        else
          {}
        end
      end

      def wd_request_params
        if params[:withdrawal_request] && !params[:withdrawal_request].empty?  
          params.require(:withdrawal_request).permit(:id, :withdrawal_id, :balance, :status)
        else
          {}
        end
      end

      def authorize
        if spree_current_user.nil?
          redirect_to login_path
          return
        end

        spree_current_user.spree_roles.each do |role|
          if role.name == 'producer'
            return
          end
        end
        raise ActionController::RoutingError.new('Not Found')
      end

      def init_user
        @user = spree_current_user
      end

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
