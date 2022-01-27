module Spree
    module Admin
      class WithdrawalBalancesController < Spree::Admin::BaseController
        before_action :set_balance, only: %i[ edit update destroy ]

        def index
          params[:q] ||= {}

          created_at_gt = params[:q][:created_at_gt]
          created_at_lt = params[:q][:created_at_lt]

          if params[:q][:created_at_gt].present?
          params[:q][:created_at_gt] = begin
                                          Time.zone.parse(params[:q][:created_at_gt]).beginning_of_day
                                      rescue StandardError
                                          ""
                                      end
          end

          if params[:q][:created_at_lt].present?
          params[:q][:created_at_lt] = begin
                                          Time.zone.parse(params[:q][:created_at_lt]).end_of_day
                                      rescue StandardError
                                          ""
                                      end
          end

          @search = Spree::WithdrawalBalance.accessible_by(current_ability, :index).ransack(params[:q])
          @search.sorts = 'created_at desc' if @search.sorts.empty?
          @balances = @search.result.includes([:user]).
            page(params[:page]).
            per(params[:per_page] || Spree::Config[:orders_per_page])
        end

        def edit
          authorize! action, @balance
        rescue ActiveRecord::RecordNotFound
          resource_not_found(flash_class: Spree::WithdrawalBalance, redirect_url: admin_withdrawal_balances_path)
        end

        def new
          @balance = Spree::WithdrawalBalance.new
        end

        def create
          authorize! :create, WithdrawalBalance

          @balance = Spree::WithdrawalBalance.new(withdrawal_balance_params)
          @user = Spree::User.find(params[:withdrawal_balance][:user_id])
          @balance.user = @user
          @balance.total = @balance.balance - @balance.tax - @balance.shipping - @balance.handling_fee
          
          respond_to do |format|
            if @balance.save
              format.html { redirect_to main_app.edit_admin_withdrawal_balance_path(@balance), notice: "Withdrawal balance was successfully created." }
              format.json { render :show, status: :created, location: main_app.admin_withdrawal_balances_path }
            else
              format.html { render :new, status: :unprocessable_entity }
              format.json { render json: @balance.errors, status: :unprocessable_entity }
            end
          end
        end

        def update
          authorize! :update, WithdrawalBalance

          @user = Spree::User.find(params[:withdrawal_balance][:user_id])
          @balance.assign_attributes(withdrawal_balance_params)
          @balance.user = @user
          @balance.total = @balance.balance - @balance.tax - @balance.shipping - @balance.handling_fee

          respond_to do |format|
            if @balance.save
              format.html { redirect_to main_app.edit_admin_withdrawal_balance_path(@balance), notice: "Withdrawal balance was successfully updated." }
              format.json { render :show, status: :created, location: main_app.admin_withdrawal_balances_path }
            else
              format.html { render :edit, status: :unprocessable_entity }
              format.json { render json: @balance.errors, status: :unprocessable_entity }
            end
          end
        end

        def destroy
          @balance.destroy
          respond_to do |format|
              format.html { redirect_to main_app.admin_withdrawal_balances_path, notice: "Withdrawal balance was successfully destroyed." }
              format.json { head :no_content }
          end
        end

        private

        def set_balance
          @balance = Spree::WithdrawalBalance.find(params[:id])
        end

        def withdrawal_balance_params
          if params[:withdrawal_balance] && !params[:withdrawal_balance].empty?
            params.require(:withdrawal_balance).permit(:id, :user_id, :order_id, :line_item_id, :balance, :handling_fee, :tax, :shipping, :total)
          else
            {}
          end
        end

      end
    end
end