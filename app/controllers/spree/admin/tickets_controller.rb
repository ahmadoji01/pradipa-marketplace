module Spree
    module Admin
        class TicketsController < Spree::Admin::BaseController

            def index
                @show_only_open = false
                @search = Spree::Ticket.accessible_by(current_ability, :index).ransack(params[:q])
                @search.sorts = 'created_at desc' if @search.sorts.empty?
                @tickets = @search.result.
                    page(params[:page]).
                    per(params[:per_page] || Spree::Config[:orders_per_page])
            end

            def new
                @ticket = Spree::Ticket.new
            end

            def edit
                @ticket = Spree::Ticket.find(params[:id])
                authorize! action, @ticket
            rescue ActiveRecord::RecordNotFound
                resource_not_found(flash_class: Spree::Ticket, redirect_url: admin_tickets_path)
            end
    
            def create
                authorize! :create, Ticket
        
                @ticket = Spree::Ticket.new(ticket_params)
                @user = Spree::User.find(params[:ticket][:user_id])
                @ticket.user = @user
                @ticket.status = 'open'
                
                respond_to do |format|
                    if @request.save
                        format.html { redirect_to main_app.edit_admin_ticket_path(@ticket), notice: "Ticket was successfully created." }
                        format.json { render :show, status: :created, location: main_app.admin_tickets_path }
                    else
                        format.html { render :new, status: :unprocessable_entity }
                        format.json { render json: @request.errors, status: :unprocessable_entity }
                    end
                end
            end

            def update
                authorize! :update, Ticket
      
                @ticket = Spree::Ticket.find(params[:id])
                @withdrawal = Spree::User.find(params[:withdrawal_request][:withdrawal_id])
                @ticket.assign_attributes(ticket_params)
                @ticket.user = @user
      
                respond_to do |format|
                  if @ticket.save
                    format.html { redirect_to main_app.edit_admin_ticket_path(@ticket), notice: "Ticket was successfully updated." }
                    format.json { render :show, status: :created, location: main_app.admin_tickets_path }
                  else
                    format.html { render :edit, status: :unprocessable_entity }
                    format.json { render json: @request.errors, status: :unprocessable_entity }
                  end
                end
              end

            private

            def ticket_params
                if params[:ticket] && !params[:ticket].empty?
                    params.require(:ticket).permit(:id, :title, :body, :picture, :user_id, :status)
                else
                    {}
                end
            end
        end
    end
end