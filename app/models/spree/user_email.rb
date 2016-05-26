module Spree
  class UserEmail < Spree::Base

    belongs_to :user, class_name: Spree.user_class

    validates :user, :email, presence: true
    validates :email, uniqueness: { scope: :user }, allow_blank: true

    after_update :update_user_email, if: :can_update_user_email?

    private

      def can_update_user_email
        primary_changed? && primary?
      end

      def update_user_email
        user.update_column :email, email
      end

  end
end
