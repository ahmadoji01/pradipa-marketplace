module Spree
    module Admin
      class WithdrawalsController < Spree::Admin::BaseController

        def index
          @search = Spree::Withdrawal.accessible_by(current_ability, :index).ransack(params[:q])
          @search.sorts = 'created_at desc' if @search.sorts.empty?
          @withdrawals = @search.result.includes([:user]).
            page(params[:page]).
            per(params[:per_page] || Spree::Config[:orders_per_page])
        end

        def edit
          @withdrawal = Spree::Withdrawal.find(params[:id])
          authorize! action, @withdrawal
        rescue ActiveRecord::RecordNotFound
          resource_not_found(flash_class: Spree::Withdrawal, redirect_url: admin_withdrawals_path)
        end

        def new
          @withdrawal = Spree::Withdrawal.new
        end

        def create
          authorize! :create, Withdrawal

          @withdrawal = Spree::Withdrawal.new(withdrawal_params)
          @user = Spree::User.find(params[:withdrawal][:user_id])
          @withdrawal.user = @user
          
          respond_to do |format|
            if @withdrawal.save
              format.html { redirect_to main_app.edit_admin_withdrawal_path(@withdrawal), notice: "Withdrawal was successfully created." }
              format.json { render :show, status: :created, location: main_app.admin_withdrawals_path }
            else
              format.html { render :new, status: :unprocessable_entity }
              format.json { render json: @withdrawal.errors, status: :unprocessable_entity }
            end
          end
        end

        def update
          authorize! :update, Withdrawal

          @withdrawal = Spree::Withdrawal.find(params[:id])
          if @withdrawal.nil?
            @withdrawal = Spree::Withdrawal.new
          end

          @user = Spree::User.find(params[:withdrawal][:user_id])
          @withdrawal.assign_attributes(withdrawal_params)
          @withdrawal.user = @user

          respond_to do |format|
            if @withdrawal.save
              format.html { redirect_to main_app.edit_admin_withdrawal_path(@withdrawal), notice: "Withdrawal was successfully updated." }
              format.json { render :show, status: :created, location: main_app.admin_withdrawals_path }
            else
              format.html { render :edit, status: :unprocessable_entity }
              format.json { render json: @withdrawal.errors, status: :unprocessable_entity }
            end
          end
        end

        private

        def withdrawal_params
          if params[:withdrawal] && !params[:withdrawal].empty?
            params.require(:withdrawal).permit(:id, :spree_user_id, :bank_name, :bank_number, :bank_swift_code, :bank_country, :full_name, :address)
          else
            {}
          end
        end

      end
    end
end