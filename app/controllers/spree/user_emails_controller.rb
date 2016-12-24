module Spree
  class UserEmailsController < Spree::BaseController

    before_action :set_user
    before_action :set_user_email, only: [:edit, :update, :destroy, :mark_primary, :resend_confirmation, :confirm]

    def new
      @user_email = @user.emails.build(email: nil)
    end

    def create
      @user_email = @user.emails.build user_email_permitted_attributes
      if @user_email.save
        flash[:success] = t(".success")
      else
        render :new
      end
    end

    def edit
    end

    def update
      if @user_email.update(user_email_permitted_attributes)
        flash[:success] = t(".success")
      else
        render :edit
      end
    end

    def destroy
      if @user_email.destroy
        flash[:success] = t(".success")
      else
        flash[:error] = t(".error")
      end
    end

    def mark_primary
      @user_email.mark_primary
      if @user_email.primary?
        flash[:success] = t(".success", email: @user_email.email)
      else
        flash[:error] = t(".error", email: @user_email.email)
      end
    end

    def resend_confirmation
      @user_email.send_confirmation_instructions
      flash[:success] = t(".success", email: @user_email.email)
    end

    def confirm
      @user_email.confirm if params[:confirmation_token] == @user_email.confirmation_token
      if @user_email.confirmed?
        flash[:success] = t(".success", email: @user_email.email)
        redirect_to account_path(@user_email.user)
      else
        flash[:error] = t(".success", email: @user_email.email)
        redirect_to account_path(@user_email.user)
      end
    end

    private

      def user_email_permitted_attributes
        params.require(:user_email).permit(:email)
      end

      def set_user
        @user = Spree.user_class.find_by(id: params[:user_id]) || spree_current_user
      end

      def set_user_email
        @user_email = Spree::UserEmail.find_by(id: params[:id])
      end

  end
end
