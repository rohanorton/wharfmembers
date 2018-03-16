Wharfmembers::Application.routes.draw do
  devise_for :users, skip: [:registrations]

  as :user do
    get '/users/edit/:id', to: 'devise/registrations#edit',   as: 'edit_user_registration'
    put '/users/:id',      to: 'devise/registrations#update', as: 'user_registration'
  end

  resources :members do
    member do
      get :renew
    end
    collection do
      get :register
      post :join
      get :current
      get :pending
      get :expired
      get :lifetime
      get :mailing_list
      get :mailing_list_no_lifetime
      get :mailing_list_expired
      post :bulk_action
    end
    resources :memberships, only: :destroy
  end


  root :to => 'members#current'
end
