module Spree
  class UserEmailsController < Spree::BaseController

    before_action :set_user
    before_action :set_user_email, :ensure_not_primary_email, only: [:edit, :update]

    def new
      @user_email = @user.emails.build
    end

    def create
      @user_email = @user.emails.build user_email_permitted_attributes
      if @user_email.save
        flash.now[:success] = "Email has been successfully saved"
      else
        render :new
      end
    end

    def edit
    end

    def update
    end

    def request_primary
    end

    private

      def user_email_permitted_attributes
        params.require(:user_email).permit(:email)
      end

      def set_user
        @user = Spree.user_class.find_by(params[:user_id]) || spree_current_user
      end

      def set_user_email
        @user_email = Spree::UserEmail.find_by(params[:id])
      end

      def ensure_not_primary_email
      end

  end
end
