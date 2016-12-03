Spree::Core::Engine.routes.draw do
  # Add your extension routes here

  resources :user_emails

  namespace :admin do
    resources :users do
      resources :user_emails
    end
  end

end
