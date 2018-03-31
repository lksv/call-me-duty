Rails.application.routes.draw do
  devise_for :users

  scope(path: '*full_path', as: :team, full_path: CMD::RoutesRegexp.safe_full_path) do
    get  :calendar, to: 'teams#calendar'
    resources :incidents
    resources :services, shallow: true do
      resources :integrations, shallow: true
    end
    resources :escalation_policies, shallow: true
    #resources :members, shallow: true
    #get '', to: 'incidents#index'
  end

  resources :teams do
    resources :incidents, shallow: true
    resources :members, shallow: true
    resources :calendars, shallow: true
    get  :calendar, on: :member, as: :calendar
  end

  resources :users

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "home#index"
end
