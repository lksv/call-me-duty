Rails.application.routes.draw do
  devise_for :users

  resources :teams do
    get  :calendar, on: :member, as: :calendar
    resources :services, shallow: true do
      resources :integrations, shallow: true
    end
    resources :escalation_policies, shallow: true
    resources :members, shallow: true
  end

  resources :incidents
  resources :users
  resources :calendars

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "home#index"
end
