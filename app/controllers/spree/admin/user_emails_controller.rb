module Spree
  module Admin
    class UserEmailsController < ResourceController

      belongs_to 'spree/user', find_by: :id

    end
  end
end
