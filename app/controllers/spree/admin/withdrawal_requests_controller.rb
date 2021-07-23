module Spree
    module Admin
      class WithdrawalRequestsController < Spree::Admin::BaseController

        def index
          params[:q] ||= {}
          params[:q][:status] ||= ''
          params[:q][:s] ||= 'status desc'

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

          @search = Spree::WithdrawalRequest.accessible_by(current_ability, :index).ransack(params[:q])
          @search.sorts = 'created_at desc' if @search.sorts.empty?
          @requests = @search.result.includes([:withdrawal]).
            page(params[:page]).
            per(params[:per_page] || Spree::Config[:orders_per_page])
          @show_only_completed = false
        end

        def edit
          @request = Spree::WithdrawalRequest.find(params[:id])
          authorize! action, @request
        rescue ActiveRecord::RecordNotFound
          resource_not_found(flash_class: Spree::WithdrawalRequest, redirect_url: admin_withdrawal_requests_path)
        end

        def new
          @request = Spree::WithdrawalRequest.new
        end

        def create
          authorize! :create, WithdrawalRequest

          @request = Spree::WithdrawalRequest.new(withdrawal_request_params)
          @withdrawal = Spree::Withdrawal.find(params[:withdrawal_request][:withdrawal_id])
          @request.withdrawal = @withdrawal
          @request.status = 'Requested'
          
          respond_to do |format|
            if @request.save
              format.html { redirect_to main_app.edit_admin_withdrawal_request_path(@request), notice: "Withdrawal request was successfully created." }
              format.json { render :show, status: :created, location: main_app.admin_withdrawal_requests_path }
            else
              format.html { render :new, status: :unprocessable_entity }
              format.json { render json: @request.errors, status: :unprocessable_entity }
            end
          end
        end

        def update
          authorize! :update, WithdrawalRequest

          @request = Spree::WithdrawalRequest.find(params[:id])
          @withdrawal = Spree::Withdrawal.find(params[:withdrawal_request][:withdrawal_id])
          @request.assign_attributes(withdrawal_request_params)
          @request.withdrawal = @withdrawal

          if @request.status == 'Completed'
            @request.completed_at = DateTime.now
          end

          respond_to do |format|
            if @request.save
              format.html { redirect_to main_app.edit_admin_withdrawal_request_path(@request), notice: "Withdrawal request was successfully updated." }
              format.json { render :show, status: :created, location: main_app.admin_withdrawal_requests_path }
            else
              format.html { render :edit, status: :unprocessable_entity }
              format.json { render json: @request.errors, status: :unprocessable_entity }
            end
          end
        end

        private

        def withdrawal_request_params
          if params[:withdrawal_request] && !params[:withdrawal_request].empty?
            params.require(:withdrawal_request).permit(:id, :withdrawal_id, :balance, :status)
          else
            {}
          end
        end

      end
    end
end