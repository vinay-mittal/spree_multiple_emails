Spree.user_class.class_eval do

  # Associations
  has_many :emails, class_name: "Spree::UserEmail", dependent: :destroy, foreign_key: :user_id
  has_one :primary_email, -> { where(primary: true) },
                          class_name: "Spree::UserEmail",
                          foreign_key: :user_id,
                          dependent: :destroy

  # Validations
  validates :primary_email, presence: true, numericality: { equal_to: 1, only_integer: true }

  # Callbacks
  before_validation :set_primary_email, on: :create

  private

    def set_primary_email
      build_primary_email email: email
    end

end
