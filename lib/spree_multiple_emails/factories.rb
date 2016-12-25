FactoryGirl.define do

  factory :spree_user_email, class: Spree::UserEmail do
    email { Faker::Internet.email }
    association :user, factory: :user

    factory :spree_primary_user_email do
      primary true
    end
  end

end
