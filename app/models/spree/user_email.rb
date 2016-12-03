module Spree
  class UserEmail < Spree::Base

    # Associations
    belongs_to :user, class_name: Spree.user_class

    # Validations
    validates :user, :email, presence: true
    validates :email, email: true
    validates :email, uniqueness: { scope: :user }, allow_blank: true

    # Callbacks
    after_update :update_user_email, if: :can_update_user_email?

    # Scopes
    scope :primary, -> { where(primary: true) }

    private

      def can_update_user_email?
        primary_changed? && primary?
      end

      def update_user_email
        user.update_column :email, email
      end

  end
end
