module Spree
    class MailingsController < Spree::StoreController

        def submit_mailing
            @mailing = Mailing.new(mailing_params)
            current_path = request.referer

            @check_mailing = Mailing.where(email: @mailing.email)
            if !@check_mailing.first.nil?
                redirect_to current_path, flash: { error: "You have already subscribed to us. Stay tuned!" }
                return
            end

            respond_to do |format|
                if @mailing.save
                    MailingMailer.with(mailing: @mailing).preopening_subs.deliver_now
                    format.html { redirect_to current_path, success: "Your subscription has been added. We will keep you informed!" }
                    format.json { render :show, status: :created, location: current_path }
                else
                    format.html { redirect_to current_path, error: "Something went wrong. Please try again in a few moment" }
                    format.json { render json: @mailing.errors, status: :unprocessable_entity }
                end
            end
        end

        private
            # Only allow a list of trusted parameters through.
            def mailing_params
                params.fetch(:mailing, {}).permit(:email, :first_name, :last_name)
            end

    end
end
