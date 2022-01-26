module Spree
  class ProducerDashboardController < Spree::StoreController
    before_action :init_withdrawal, only: [:index, :request_withdrawal]
    before_action :init_user
    before_action :authorize
    before_action :set_default_settings
    before_action :count_currency_value, only: [:index, :withdrawals, :withdrawal_balances, :request_withdrawal, :orders, :products]
    before_action :set_avatar, only: [:index, :orders, :products, :payment_info, :withdrawals, :request_withdrawal, :support, :brand_info, :contact_info, :change_password, :shipping_requests, :notifications, :show_shipping_request]
    before_action :set_short_notifs, only: [:index, :orders, :products, :payment_info, :withdrawals, :request_withdrawal, :support, :brand_info, :contact_info, :change_password, :shipping_requests, :notifications, :show_shipping_request]
    layout 'spree/layouts/producer_dashboard'
    attr_accessor :available_balance

    def index
      @line_items = Spree::LineItem.joins(:product).where(:product => {:user_id => @user.id}).last(5)
      @shipped_items = count_shipped_items(@line_items)
      @info = Spree::Withdrawal.where(:user_id => @user.id)
      @requests = OrderNotification.where(notif_type: "shipping_request", user_id: @user.id, status: 'pending')
      @wd_requests = Spree::WithdrawalRequest.joins(:withdrawal).where(:withdrawal => {:user_id => @user.id}).last(5)
      @wd_balances = Spree::WithdrawalBalance.where(:user_id => @user.id).last(5)
      count_balance(@wd_balances)

      withdrawn_balance(@wd_requests)
      @available_balance = @balance - @wd_balance
    end

    def redirect_to_home
      redirect_to main_app.producer_dashboard_home_page_path
    end

    def orders
      @pagy, @line_items = pagy(Spree::LineItem.joins(:product).where(:product => {:user_id => @user.id}), items: 10)
    end

    def products
      @user_products = Spree::Product.where(:user_id => @user.id)
      @q = @user_products.ransack(params[:q])
      @pagy, @products = pagy(@q.result, items: 10)
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
          format.html { redirect_to main_app.producer_dashboard_payment_info_page_path, info: I18n.t('pd.payment_info_updated') }
          format.json { render :show, status: :created, location: main_app.producer_dashboard_payment_info_page_path }
        else
          format.html { redirect_to main_app.producer_dashboard_payment_info_page_path, danger: I18n.t('pd.server_error') }
          format.json { render json: @withdrawal.errors, status: :unprocessable_entity }
        end
      end
    end

    def withdrawals
      @wd_requests = Spree::WithdrawalRequest.joins(:withdrawal).where(:withdrawal => {:user_id => @user.id}).last(5)
      @wd_balances = Spree::WithdrawalBalance.where(:user_id => @user.id).last(5)
    end

    def withdrawal_requests
      @pagy, @wd_requests = pagy(Spree::WithdrawalRequest.joins(:withdrawal).where(:withdrawal => {:user_id => @user.id}))
    end

    def withdrawal_balances
      @pagy, @wd_balances = pagy(Spree::WithdrawalBalance.where(:user_id => @user.id))
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
        flash[:warning] = I18n.t('pd.wd_info_must_be_filled')
        redirect_to main_app.producer_dashboard_payment_info_page_path
        return
      end

      @request = Spree::WithdrawalRequest.new
      @request.balance = params[:withdrawal_request][:balance].to_d

      if @request.balance <= 0.0
        flash[:warning] = I18n.t('pd.wd_cannot_be_zero')
        redirect_to main_app.producer_dashboard_request_withdrawal_page_path
        return
      end
      
      if I18n.t('currency_code') != 'USD'
        currency_value = CurrencyValue.where(currency_from: 'USD', currency_to: I18n.t('currency_code'))
      end

      value = 1
      if !currency_value.empty?
        value = currency_value.first.value
        @request.balance /= value 
      end

      if @request.balance > params[:withdrawal_request][:available_balance].to_d
        respond_to do |format|
          format.html { redirect_to main_app.producer_dashboard_request_withdrawal_page_path, warning: I18n.t('pd.wd_exceeds_balance') }
        end
        return
      end

      @request.withdrawal = @withdrawal
      @request.status = 'Requested'
      
      respond_to do |format|
        if @request.save
          format.html { redirect_to main_app.producer_dashboard_request_withdrawal_page_path, info: I18n.t('pd.wd_request_created') }
          format.json { render :show, status: :created, location: main_app.producer_dashboard_request_withdrawal_page_path }
        else
          format.html { redirect_to main_app.producer_dashboard_request_withdrawal_page_path, danger: I18n.t('pd.server_error') }
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
      @ticket.name = ''
      @ticket.email = ''

      respond_to do |format|
        if @ticket.save
          format.html { redirect_to main_app.producer_dashboard_support_page_path, info: I18n.t('pd.ticket_created') }
          format.json { render :show, status: :created, location: main_app.producer_dashboard_support_page_path }
        else
          format.html { redirect_to main_app.producer_dashboard_support_page_path, danger: I18n.t('pd.server_error') }
          format.json { render json: @ticket.errors, status: :unprocessable_entity }
        end
      end
    end

    def brand_info
      set_brand()

      if spree_current_user.bill_address.nil?
        @address = Spree::Address.build_default
      else
        @address = spree_current_user.bill_address
      end
    end

    def contact_info
      if spree_current_user.bill_address.nil?
        @address = Spree::Address.build_default
      else
        @address = spree_current_user.bill_address
      end
    end

    def change_password
      
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
          format.html { redirect_to main_app.producer_dashboard_brand_info_page_path, info: I18n.t('pd.brand_info_updated') }
          format.json { render :show, status: :created, location: main_app.producer_dashboard_brand_info_page_path }
        else
          format.html { redirect_to main_app.producer_dashboard_brand_info_page_path, danger: I18n.t('pd.server_error') }
          format.json { render json: @brand.errors, status: :unprocessable_entity }
        end
      end
    end

    def submit_contact_info
      @address = Spree::Address.new(bill_address_params)
      @user.bill_address = @address

      respond_to do |format|
        if @user.save
          format.html { redirect_to main_app.producer_dashboard_contact_info_page, info: I18n.t('pd.contact_info_updated') }
          format.json { render :show, status: :created, location: main_app.producer_dashboard_contact_info_page }
        else
          format.html { redirect_to main_app.producer_dashboard_contact_info_page, danger: I18n.t('pd.server_error') }
          format.json { render json: @brand.errors, status: :unprocessable_entity }
        end
      end
    end

    def notifications
      @notifications = OrderNotification.where(user_id: @user.id)
    end

    def shipping_requests
      params[:q] ||= {}

      if params[:q][:status_eq].nil?
        params[:q][:status_eq] = 'pending'
      end

      @q = OrderNotification.where(notif_type: "shipping_request", user_id: @user.id).ransack(params[:q])
      @pagy, @requests = pagy(@q.result, items: 10)
    end

    def show_shipping_request
      @request = OrderNotification.find(params[:id])
      
      if @request.nil?
        redirect_to main_app.producer_dashboard_home_page_path
        return
      end

      if @user.id != @request.user_id
        redirect_to main_app.producer_dashboard_home_page_path
        return
      end
    end

    def update_notif
      @request = OrderNotification.find(params[:order_notification][:id])
      @request.assign_attributes(order_notif_params)

      respond_to do |format|
        if @request.save
          format.html { redirect_to main_app.producer_dashboard_shipping_request_page_path(@request), info: I18n.t('pd.notif_updated') }
          format.json { render :show, status: :created, location: main_app.producer_dashboard_shipping_request_page_path(@request) }
        else
          format.html { redirect_to main_app.producer_dashboard_support_page_path, danger: I18n.t('pd.server_error') }
          format.json { render json: @request.errors, status: :unprocessable_entity }
        end
      end
    end

    def update_notif_read_status
      notifs = OrderNotification.where(user_id: spree_current_user.id, read: false)

      notifs.each do |notif|
        notif = OrderNotification.find(notif.id)
        notif.read = true
        notif.save
      end
    end

    def change_locale
      locale = :en
      if !params[:locale].nil?
        locale = params[:locale]
      end

      set_producer_setting("language", locale)
    end

    private

      def set_default_settings
        user = spree_current_user
        lang_setting = ProducerSetting.where(user_id: user.id, key: "language")

        if !lang_setting.empty?
          I18n.locale = lang_setting.first.value
        end
      end

      def set_producer_setting(key, value)
        user = spree_current_user
        setting = ProducerSetting.where(key: key, user_id: user.id)

        if setting.empty?
          setting = ProducerSetting.new
          setting.key = key
          setting.value = value
          setting.user = user
        else
          setting = setting.first
          setting.key = key
          setting.value = value
        end

        respond_to do |format|
          if setting.save
            format.html { redirect_to request.referer, info: I18n.t('pd.language_updated') }
            format.json { render :show, status: :created, location: request.referer }
          else
            format.html { redirect_to request.referer, danger: I18n.t('pd.server_error') }
            format.json { render json: setting.errors, status: :unprocessable_entity }
          end
        end
      end

      def count_currency_value
        from = "USD"
        to = I18n.t 'currency_code'

        @currency_value = CurrencyValue.where(currency_from: from, currency_to: to).first
      end

      def notif_display(notification)
        if notification.notif_type == "shipping_request"
          case notification.title
          when "new"
            return I18n.t 'notif.new_shipping_request'
          else
            return ""
          end
        end
      end

      def set_short_notifs
        @is_notif_empty = false
        @short_notifs = OrderNotification.where(user_id: spree_current_user.id, read: false)

        if @short_notifs.empty?
          @is_notif_empty = true
        end
      end

      def set_avatar
        @avatar = ''
        brand = Spree::Brand.where(user_id: spree_current_user.id).first
        if !brand.nil?
          if brand.brand_photo_url
            @avatar = brand.brand_photo
          end
        end
      end

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

      def order_notif_params
        if params[:order_notification] && !params[:order_notification].empty?  
          params.require(:order_notification).permit(:id, :user_id, :order_id, :notif_type, :title, :read, :status)
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

      def bill_address_params
        if params[:address] && !params[:address].empty?
          params.require(:address).permit(:id, :user_id, :name, :company, :address1, :address2, :city, :country_id, :state_id, :zipcode, :phone, :alternative_phone)
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
          if request.status.downcase == 'completed' || request.status.downcase == 'processing'
            @wd_balance += request.balance
          end
        end
      end
  end
end
