Rails.application.routes.draw do
  # Shopify internal_app
  mount InternalApp::Engine => "/"

  # Disable rails_admin as we don't want this running in cloud
  # mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  get '/' => redirect('/projects')

  resources :projects, param: :slug, only: [:index] do
    resources :suites, param: :slug, only: [:show] do
      resources :runs, param: :sequential_id, only: [:show]
    end
  end

  resources :runs, only: [:new, :create]
  resources :tests, only: [:update, :new, :create]

  get '/baselines/:key', to: 'baselines#show', as: :baseline
end
