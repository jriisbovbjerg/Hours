devise_for :users, controllers: { registrations: "users/registrations" }
resources :archives, only: [:index]
resources :projects, only: [:index, :edit, :new, :update, :create, :show] do
  resources :audits, only: [:index]
end
resources :categories, only: [:index, :create, :edit, :update]
resources :assignments, only: [:index, :new, :create, :edit, :update, :destroy]
resources :entries, only: [:index]

resources :hours, :mileages, :expenses, only: [:create, :destroy, :update, :edit, :patch]do
  resources :audits, only: [:index]
end

resources :reports, only: [:index]

resources :billables, only: [:index, :show]

resources :users, only: [:index, :update, :show] do
  resources :entries, only: [:index]
end

resources :invoices, only: [:index, :update, :edit, :show]
resources :tags, only: [:show]
resources :clients, only: [:show, :index, :edit, :update, :create]
resources :contacts, only: [:show, :index, :edit, :update, :create]

get "report/wage" => "reports#wage", as: :wage_report
get "user/edit" => "users#edit", as: :edit_user
get "account/edit" => "accounts#edit", as: :edit_account
delete "account" => "accounts#destroy", as: :destroy_account
post "billables" => "billables#bill_entries", as: :bill_entries
