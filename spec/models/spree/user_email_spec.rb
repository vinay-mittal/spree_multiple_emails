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

  describe "#confirm" do
    before { user_email.confirm }

    it { expect(user_email.confirmed_at).to_not be_nil }
  end

  describe "#send_confirmation_instructions" do
    context "when user email is primary" do
      it { expect { primary_user_email.send_confirmation_instructions }.to change { ActionMailer::Base.deliveries.count }.by(0) }
    end

    context "when user email is not primary" do
      before { ActionMailer::Base.default_url_options[:host] = "https://test.example.com" }

      xit { expect { user_email.send_confirmation_instructions }.to change { ActionMailer::Base.deliveries.count }.by(1) }
    end
  end

  describe "#confirmed?" do
    before { user_email.confirm }

    it { expect(user_email.confirmed?).to be_truthy }
  end

  describe "#confirmable?" do
    context "when configuration is set for confirmation" do
      # before { Spree::Auth::Config[:confirmable] = true }

      # it { expect(user_email.send(:confirmable?)).to be_truthy }

      # after { Spree::Auth::Config[:confirmable] = false }
    end

    context "when configuration is not set for confirmation" do
      it { expect(user_email.send(:confirmable?)).to be_falsey }
    end
  end

  describe "#primary_markable?" do
    context "when confirmed? and confirmable? both returns true" do
      before do
        allow(user_email).to receive(:confirmable?).and_return(true)
        allow(user_email).to receive(:confirmed?).and_return(true)
      end

      context "expects to receive" do
        it { expect(user_email).to receive(:confirmable?).and_return(true) }
        it { expect(user_email).to receive(:confirmed?).and_return(true) }

        after { user_email.primary_markable? }
      end

      context "returns" do
        it { expect(user_email.primary_markable?).to be_truthy }
      end
    end

    context "when confirmed? and confirmable? both returns false" do
      before do
        allow(user_email).to receive(:confirmable?).and_return(false)
        allow(user_email).to receive(:confirmed?).and_return(false)
      end

      context "expects to receive" do
        it { expect(user_email).to receive(:confirmable?).and_return(false) }

        after { user_email.primary_markable? }
      end

      context "returns" do
        it { expect(user_email.primary_markable?).to be_truthy }
      end
    end

    context "when confirmed? returns true and confirmable? returns false" do
      before do
        allow(user_email).to receive(:confirmable?).and_return(false)
        allow(user_email).to receive(:confirmed?).and_return(true)
      end

      context "expects to receive" do
        it { expect(user_email).to receive(:confirmable?).and_return(false) }

        after { user_email.primary_markable? }
      end

      context "returns" do
        it { expect(user_email.primary_markable?).to be_truthy }
      end
    end

    context "when confirmed? returns false and confirmable? returns true" do
      before do
        allow(user_email).to receive(:confirmable?).and_return(true)
        allow(user_email).to receive(:confirmed?).and_return(false)
      end

      context "expects to receive" do
        it { expect(user_email).to receive(:confirmable?).and_return(true) }
        it { expect(user_email).to receive(:confirmed?).and_return(false) }

        after { user_email.primary_markable? }
      end

      context "returns" do
        it { expect(user_email.primary_markable?).to be_falsey }
      end
    end
  end

  describe "#mark_primary" do
    let!(:user) { create(:user) }
    let!(:primary_email) { user.primary_email }
    let(:user_email) { create(:spree_user_email, user: user) }

    context "when user email is primary markable" do
      before { allow(user_email).to receive(:primary_markable?).and_return(true) }

      context "expects to receive" do
        it { expect(user_email).to receive(:primary_markable?).and_return(true) }

        after { user_email.mark_primary }
      end

      context "returns" do
        before { user_email.mark_primary }

        it { expect(user_email.primary?).to be_truthy }
        it { expect(primary_email.reload.primary?).to be_falsey }
      end
    end

    context "when user email is not primary markable" do
      before { allow(user_email).to receive(:primary_markable?).and_return(false) }

      context "expects to receive" do
        it { expect(user_email).to receive(:primary_markable?).and_return(false) }

        after { user_email.mark_primary }
      end

      context "returns" do
        before { user_email.mark_primary }

        it { expect(user_email.primary?).to be_falsey }
        it { expect(primary_email.reload.primary?).to be_truthy }
      end
    end
  end

  describe "#update_user_email" do
    let(:primary_user_email) { create(:spree_primary_user_email) }
    let(:user) { primary_user_email.user }

    before { primary_user_email.send(:update_user_email) }

    it { expect(user.email).to eq primary_user_email.email }
    it { expect(user.login).to eq primary_user_email.email }
  end

  describe "#set_confirmation_token" do
    let(:nil_user_email) { build(:spree_user_email, confirmation_token: nil) }

    before { nil_user_email.send :set_confirmation_token }

    it { expect(nil_user_email.confirmation_token).to_not be_nil }
  end

end
