require "spec_helper"

RSpec.describe Spree::UserEmail, type: :model do

  let(:user_email) { create(:spree_user_email) }
  let(:primary_user_email) { create(:spree_primary_user_email) }

  describe "Validations" do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:user) }
    xit { is_expected.to validate_uniqueness_of(:email).scoped_to(:user) }
  end

  describe "Associations" do
    it { is_expected.to belong_to(:user).class_name(Spree.user_class.to_s) }
  end

  describe "Callbacks" do
    it { is_expected.to callback(:set_confirmation_token).before(:validation).on(:create).if(:confirmable?) }
    it { is_expected.to callback(:update_user_email).after(:update) }
    it { is_expected.to callback(:send_confirmation_instructions).after(:commit).on(:create).if(:confirmable?) }
  end

  describe "Scopes" do
    context ".primary" do
      before do
        user_email
        primary_user_email
      end

      it { expect(Spree::UserEmail.primary).to include primary_user_email }
      it { expect(Spree::UserEmail.primary).to_not include user_email }
    end
  end

end
