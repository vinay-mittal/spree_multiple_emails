class AddConfirmationToSpreeUserEmails < ActiveRecord::Migration
  def change
    add_column :spree_user_emails, :confirmed_at, :datetime
    add_column :spree_user_emails, :confirmation_token, :string
  end
end
