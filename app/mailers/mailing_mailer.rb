class MailingMailer < ApplicationMailer
    def preopening_subs
        @coupon_code = "PRADOPEN20OFF"
        @mailing = params[:mailing]
        mail(to: @mailing.email, subject: 'Thank you for subscribing to us! Here is your coupon for 20% off of all orders')
    end
end
