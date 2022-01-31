class ProducerMailer < ApplicationMailer
    def order_notif_to_user
        @order = params[:order]
        @user = params[:user]
        @notification = params[:notification]
        I18n.with_locale(params[:locale]) do
            mail(to: @user.email, subject: I18n.t('mailer.producer.order_notif_subject'))
        end
    end
end
