module Spree
    module Admin
      class WithdrawalRequestsController < Spree::Admin::BaseController

        def index
          @requests = Spree::WithdrawalRequest.all
          @search = Spree::WithdrawalRequest.accessible_by(current_ability, :index).ransack(params[:q])
          @requests = @search.result.includes([:user]).
            page(params[:page]).
            per(params[:per_page] || Spree::Config[:orders_per_page])
          @show_only_completed = false
        end

        def edit
          @withdrawalrequest = Spree::WithdrawalRequest.find_by!(number: params[:id])
          authorize! action, @withdrawalrequest
        rescue ActiveRecord::RecordNotFound
          resource_not_found(flash_class: Spree::WithdrawalRequest, redirect_url: admin_withdrawal_requests_path)
        end

      end
    end
end