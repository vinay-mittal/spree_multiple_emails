module Spree
  class UserEmail < Spree::Base

    # Associations
    belongs_to :user, class_name: Spree.user_class

    # Validations
    validates :user, :email, presence: true
    validates :email, email: true
    validates :email, uniqueness: { scope: :user }, allow_blank: true

    # Scopes
    scope :primary, -> { where(primary: true) }

  end
end
