module Spree
  class StaticPagesController < Spree::StoreController
    layout :resolve_layout

    def how_to_order
    end

    def coming_soon
      @mailing = Mailing.new
    end

    def about
    end

    def terms_and_conditions
    end

    def privacy_policy
    end

    def return_policy
    end

    def faq
    end

    def order_status
    end

    def track_my_package
    end

    def contact_us
      @subject = ""
      if !request.GET['subject'].nil?
        if request.GET['subject'] == "custom-request"
          @subject = "Personalized Request: (Replace this sentence with your query)"
        end

        if request.GET['subject'] == "wholesale-partnership"
          @subject = "Wholesale Partnership: (Replace this sentence with your query)"
        end
      end

      @ticket = Ticket.new
    end

    def submit_ticket
      @ticket = Ticket.new(ticket_params)
      @ticket.status = 'open'

      respond_to do |format|
        if @ticket.save
          format.html { redirect_to main_app.contact_us_page_path, info: "Ticket was successfully created. We will reach you via your email" }
          format.json { render :show, status: :created, location: main_app.producer_dashboard_support_page_path }
        else
          format.html { redirect_to main_app.contact_us_page_path, danger: "Whoops, it is on us. We cannot process your request. Please try again" }
          format.json { render json: @ticket.errors, status: :unprocessable_entity }
        end
      end
    end

    private

      def resolve_layout
        if action_name == "coming_soon"
          "spree/layouts/full_screen"
        else
          "spree/layouts/spree_application"
        end
      end

      def set_user
        if !spree_current_user.nil?
          @user = spree_current_user
        end
      end

      def ticket_params
        if params[:ticket] && !params[:ticket].empty?
          params.require(:ticket).permit(:id, :user_id, :title, :body, :status, :picture, :name, :email)
        else
          {}
        end
      end

  end
end

