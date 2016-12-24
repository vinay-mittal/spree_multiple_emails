module Spree
  class MultipleEmailsAbility

    include CanCan::Ability

    def initialize(user)
      if user.admin?
        cannot :manage, Spree::UserEmail, primary: true
      else
        can :manage, Spree::UserEmail, primary: false
      end
    end

  end
end

Spree::Ability.register_ability(Spree::MultipleEmailsAbility)
