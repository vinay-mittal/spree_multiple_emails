Spree.user_class.class_eval do

  # Associations
  has_many :emails, class_name: "Spree::UserEmail", dependent: :destroy, foreign_key: :user_id
  has_one :primary_email, -> { primary },
                          class_name: "Spree::UserEmail",
                          foreign_key: :user_id,
                          dependent: :destroy

  # Validations
  validates :primary_email, presence: true

  # Callbacks
  before_validation :set_primary_email, on: :create
  after_update :update_primary_email, if: :email_changed?
  after_update :set_primary_email_confirmation, if: [:confirmed_at_changed?, :confirmed?]

  alias_method :user_emails, :emails

  private

    def set_primary_email
      build_primary_email email: email
    end

    def update_primary_email
      primary_email.update(email: email)
    end

    def set_primary_email_confirmation
      primary_email.update(confirmed_at: Time.current)
    end

end
