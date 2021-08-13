module Spree
  class ProducerDashboardController < Spree::StoreController

    before_action :init_withdrawal, only: [:index, :request_withdrawal]
    before_action :set_brand, only: [:brand_info]
    before_action :init_user
    before_action :authorize
    layout 'spree/layouts/producer_dashboard'
    attr_accessor :available_balance

    def index
      @line_items = Spree::LineItem.joins(:product).where(:product => {:user_id => @user.id}).last(5)
      @shipped_items = count_shipped_items(@line_items)
      @info = Spree::Withdrawal.where(:user_id => @user.id)
      @wd_requests = Spree::WithdrawalRequest.joins(:withdrawal).where(:withdrawal => {:user_id => @user.id}).last(5)
      @wd_balances = Spree::WithdrawalBalance.where(:user_id => @user.id)
      count_balance(@wd_balances)

      withdrawn_balance(@wd_requests)
      @available_balance = @balance - @wd_balance
    end

    def redirect_to_home
      redirect_to main_app.producer_dashboard_home_page_path
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
          format.html { redirect_to main_app.producer_dashboard_payment_info_page_path, info: "Withdrawal was successfully updated." }
          format.json { render :show, status: :created, location: main_app.producer_dashboard_payment_info_page_path }
        else
          format.html { redirect_to main_app.producer_dashboard_payment_info_page_path, danger: "Whoops, it is on us. We cannot process your request. Please try again" }
          format.json { render json: @withdrawal.errors, status: :unprocessable_entity }
        end
      end
    end

    def withdrawals
      @wd_requests = Spree::WithdrawalRequest.joins(:withdrawal).where(:withdrawal => {:user_id => @user.id})
      @wd_balances = Spree::WithdrawalBalance.where(:user_id => @user.id)
    end

    def request_withdrawal
      @line_items = Spree::LineItem.joins(:product).where(:product => {:user_id => @user.id})
      @shipped_items = count_shipped_items(@line_items)
      @wd_requests = Spree::WithdrawalRequest.joins(:withdrawal).where(:withdrawal => {:user_id => @user.id}).last(5)
      @wd_request = Spree::WithdrawalRequest.new
      @wd_balances = Spree::WithdrawalBalance.where(:user_id => @user.id)
      count_balance(@wd_balances)
      
      withdrawn_balance(@wd_requests)
      @available_balance = @balance - @wd_balance
    end

    def create_wd_request
      @withdrawal = Spree::Withdrawal.where(:user_id => @user.id).first
      if @withdrawal.nil?
        flash[:warning] = "You have to fill in your bank information where the withdrawal will be sent"
        redirect_to main_app.producer_dashboard_payment_info_page_path
        return
      end

      @request = Spree::WithdrawalRequest.new
      @request.balance = params[:withdrawal_request][:balance]

      if @request.balance <= 0.0
        flash[:warning] = "Withdrawal balance cannot be zero"
        redirect_to main_app.producer_dashboard_request_withdrawal_page_path
        return
      end

      if @request.balance > params[:withdrawal_request][:available_balance].to_d
        respond_to do |format|
          format.html { redirect_to main_app.producer_dashboard_request_withdrawal_page_path, warning: "Your requested withdrawal exceeds the available balance" }
        end
        return
      end

      @request.withdrawal = @withdrawal
      @request.status = 'Requested'
      
      respond_to do |format|
        if @request.save
          format.html { redirect_to main_app.producer_dashboard_request_withdrawal_page_path, info: "Withdrawal request was successfully created." }
          format.json { render :show, status: :created, location: main_app.producer_dashboard_request_withdrawal_page_path }
        else
          format.html { redirect_to main_app.producer_dashboard_request_withdrawal_page_path, danger: "Whoops, it is on us. We cannot process your request. Please try again" }
          format.json { render json: @request.errors, status: :unprocessable_entity }
        end
      end
    end

    def support
      @ticket = Ticket.new
    end

    def submit_ticket
      @ticket = Ticket.new(ticket_params)
      @ticket.status = 'open'

      respond_to do |format|
        if @ticket.save
          format.html { redirect_to main_app.producer_dashboard_support_page_path, info: "Ticket was successfully created. We will reach you via your email" }
          format.json { render :show, status: :created, location: main_app.producer_dashboard_support_page_path }
        else
          format.html { redirect_to main_app.producer_dashboard_support_page_path, danger: "Whoops, it is on us. We cannot process your request. Please try again" }
          format.json { render json: @request.errors, status: :unprocessable_entity }
        end
      end
    end

    def brand_info
    end

    def submit_brand_info
      @brand = Spree::Brand.where(user_id: spree_current_user.id).first
      if @brand.nil?
        @brand = Spree::Brand.new(brand_params)
      else
        @brand.assign_attributes(brand_params)
      end

      respond_to do |format|
        if @brand.save
          format.html { redirect_to main_app.producer_dashboard_brand_info_page_path, info: "Brand info was successfully updated" }
          format.json { render :show, status: :created, location: main_app.producer_dashboard_brand_info_page_path }
        else
          format.html { redirect_to main_app.producer_dashboard_brand_info_page_path, danger: "Whoops, it is on us. We cannot process your request. Please try again" }
          format.json { render json: @brand.errors, status: :unprocessable_entity }
        end
      end
    end

    private

      def set_brand
        @brand = Spree::Brand.where(user_id: spree_current_user.id).first
        if @brand.nil?
          @brand = Spree::Brand.new
          @brand.user = @user
        end
      end

      def withdrawal_params
        if params[:withdrawal] && !params[:withdrawal].empty?
          params.require(:withdrawal).permit(:id, :spree_user_id, :bank_name, :bank_number, :bank_swift_code, :bank_country, :full_name, :address)
        else
          {}
        end
      end

      def wd_request_params
        if params[:withdrawal_request] && !params[:withdrawal_request].empty?  
          params.require(:withdrawal_request).permit(:id, :withdrawal_id, :available_balance, :balance, :status)
        else
          {}
        end
      end

      def ticket_params
        if params[:ticket] && !params[:ticket].empty?
          params.require(:ticket).permit(:id, :user_id, :title, :body, :status, :picture)
        else
          {}
        end
      end

      def brand_params
        if params[:brand] && !params[:brand].empty?
          params.require(:brand).permit(:id, :user_id, :name, :description, :brand_banner, :brand_photo)
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

      def count_balance(wd_balances)
        wd_balances.each do |wd_balance|
          @balance += wd_balance.total
        end
      end

      def count_shipped_items(line_items)
        results = []
        line_items.each do |line_item|
          if line_item.order.shipment_state == 'shipped'
            results.push(line_item)
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
