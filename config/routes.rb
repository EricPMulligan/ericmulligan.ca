Rails.application.routes.draw do
  resources :passwords, controller: 'clearance/passwords', only: [:create, :new]
  resource :session, controller: 'clearance/sessions', only: [:create]

  resources :users, controller: 'clearance/users', only: [:create] do
    resource :password, controller: 'clearance/passwords', only: [:create, :edit, :update]
  end

  get    'sign-in'  => 'clearance/sessions#new',     as: 'sign_in'
  delete 'sign-out' => 'clearance/sessions#destroy', as: 'sign_out'
  get    'sign-up'  => 'clearance/users#new',        as: 'sign_up'

  get 'about-me' => 'static_pages#about', as: :about

  get 'coding' => 'categories#coding', as: :coding
  get 'music'  => 'categories#music',  as: :music
  get 'other'  => 'categories#other',  as: :other

  get 'contact-me' => 'contact#index', as: :contact

  root to: 'posts#index'

  get 'new'        => 'posts#new',    as: :new_post
  get ':slug'      => 'posts#show',   as: :show_post
  get ':slug/edit' => 'posts#edit',   as: :edit_post
  post ''          => 'posts#create', as: :posts
  match ':slug'    => 'posts#update', via: [:put, :patch]
end
