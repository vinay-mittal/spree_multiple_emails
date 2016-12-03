module Spree
  module Admin
    class UserEmailsController < ResourceController

      belongs_to 'spree/user', find_by: :id

      before_action :ensure_not_primary_email, only: [:edit, :update, :destroy]

      private

        def ensure_not_primary_email
          if @user_email.primary?
            flash[:error] = 'You cannot modify primary email.'
            redirect_to collection_url
          end
        end

    end
  end
end
