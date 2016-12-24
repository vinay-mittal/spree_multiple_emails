module Spree
  class UserEmailMailer < BaseMailer

    def confirmation_instructions(user_email)
      @confirmation_url = spree.confirm_user_email_url(user_email, confirmation_token: user_email.confirmation_token, host: Spree::Store.current.url)
      @email = user_email.email

      mail to: @email, from: from_address, subject: Spree::Store.current.name + ' ' + I18n.t(:subject, scope: [:devise, :mailer, :confirmation_instructions])
    end

  end
end
