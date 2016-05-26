class CreateSpreeUserMails < ActiveRecord::Migration
  def change
    create_table :spree_user_emails do |t|
      t.string :email
      t.boolean :primary, default: false
      t.references :user, index: true
    end
  end
end
