Spree::Core::Engine.routes.draw do
  # Add your extension routes here

  resources :user_emails do
    member do
      get :mark_primary
      get :resend_confirmation
      get :confirm
    end
  end

  namespace :admin do
    resources :users do
      resources :user_emails
    end
  end

end
