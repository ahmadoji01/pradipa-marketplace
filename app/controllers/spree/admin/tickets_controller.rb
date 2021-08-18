module Spree
    module Admin
        class TicketsController < Spree::Admin::BaseController
            before_action :set_ticket, only: %i[ edit update destroy ]

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
                
                if params[:ticket][:user_id] != ""
                    @user = Spree::User.find(params[:ticket][:user_id])
                    @ticket.user = @user
                end
                
                @ticket.assign_attributes(ticket_params)
                
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

            
            # DELETE /spree/blogs/1 or /spree/blogs/1.json
            def destroy
                @ticket.destroy
                respond_to do |format|
                    format.html { redirect_to main_app.admin_tickets_path, notice: "Ticket was successfully destroyed." }
                    format.json { head :no_content }
                end
            end

            private

            def set_ticket
                @ticket = Spree::Ticket.find(params[:id])
            end

            def ticket_params
                if params[:ticket] && !params[:ticket].empty?
                    params.require(:ticket).permit(:id, :title, :body, :picture, :user_id, :status, :name, :email)
                else
                    {}
                end
            end
        end
    end
end