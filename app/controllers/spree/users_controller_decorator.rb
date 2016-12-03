Spree::UsersController.class_eval do

  before_action :assign_user_emails, only: :show

  private

    def assign_user_emails
      @my_emails = @user.emails
    end

end
