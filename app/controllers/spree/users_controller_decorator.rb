Spree::UsersController.class_eval do

  before_action :assign_user_emails, only: :show

  def request_edit_primary_email
    @user.request_edit_primary_email(params)
  end

  def edit_primary_email
  end

  def update_primary_email
  end

  private

    def assign_user_emails
      @my_emails = @user.emails
    end

end
