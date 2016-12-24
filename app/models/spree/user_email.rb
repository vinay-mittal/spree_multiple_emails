module Spree
  class UserEmail < Spree::Base

    # Associations
    belongs_to :user, class_name: Spree.user_class

    # Validations
    validates :user, :email, presence: true
    validates :email, email: true
    validates :email, uniqueness: { scope: :user }, allow_blank: true

    # Callbacks
    before_validation :set_confirmation_token, on: :create, if: :confirmable?
    after_update :update_user_email, if: [:primary_changed?, :primary?]
    after_commit :send_confirmation_instructions, on: :create, if: :confirmable?

    # Scopes
    scope :primary, -> { where(primary: true) }

    def mark_primary
      if primary_markable?
        user.primary_email.update(primary: false)
        self.update(primary: true)
      end
    end

    def send_confirmation_instructions
      unless primary?
        Spree::UserEmailMailer.confirmation_instructions(self).deliver
      end
    end

    def confirm
      update(confirmed_at: Time.current)
    end

    def confirmed?
      confirmed_at.present?
    end

    def primary_markable?
      !confirmable? || (confirmable? && confirmed?)
    end

    private

      def confirmable?
        Spree::Auth::Config[:confirmable]
      end

      def update_user_email
        # Now all the user related operations will happend through this email including login.
        user.update(email: email, login: email)
      end

      def set_confirmation_token
        self.confirmation_token = Devise.friendly_token
      end

  end
end
