require "spec_helper"

RSpec.describe Spree::User, type: :model do

  describe "Associations" do
    it { is_expected.to have_many(:emails).class_name("Spree::UserEmail").with_foreign_key(:user_id).dependent(:destroy) }
    xit { is_expected.to have_one(:primary_email).conditions(-> { primary }).class_name("Spree::UserEmail").with_foreign_key(:user_id).dependent(:destroy) }
  end

  describe "Callbacks" do
    it { is_expected.to callback(:set_primary_email).before(:validation).on(:create) }
    it { is_expected.to callback(:update_primary_email).after(:update).if(:email_changed?) }
    it { is_expected.to callback(:set_primary_email_confirmation).after(:update) }
  end

  describe "#set_primary_email_confirmation" do
    let(:user) { create(:user) }
    let(:primary_user_email) { user.primary_email }

    before { user.send(:set_primary_email_confirmation) }

    it { expect(primary_user_email.confirmed_at).to_not be_nil }
  end

  describe "#update_primary_email" do
    let(:user) { create(:user) }
    let(:primary_user_email) { user.primary_email }
    let(:email) { FFaker::Internet.email }

    before { user.update(email: email) }

    it { expect(primary_user_email.email).to eq email }
  end

  describe "#set_primary_email" do
    let(:user) { build(:user) }

    before { user.send(:set_primary_email) }

    it { expect(user.primary_email).to_not be_nil }
    it { expect(user.primary_email.email).to eq user.email }
  end

end
