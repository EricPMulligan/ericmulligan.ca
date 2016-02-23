Rails.application.routes.draw do
  resource :session, controller: 'clearance/sessions', only: [:create]

  get    'sign-in'  => 'clearance/sessions#new',     as: 'sign_in'
  delete 'sign-out' => 'clearance/sessions#destroy', as: 'sign_out'
  get    'sign-up'  => 'clearance/users#new',        as: 'sign_up'

  get 'about-me' => 'static_pages#about', as: :about

  get 'coding' => 'categories#coding', as: :coding
  get 'music'  => 'categories#music',  as: :music
  get 'other'  => 'categories#other',  as: :other

  get  'contact-me' => 'contact#index',  as: :contact
  post 'contact-me' => 'contact#create'

  root to: 'posts#index'

  resources :categories
  resources :posts, only: [:update, :destroy]

  get 'index'      => 'posts#index_rss', as: :posts_rss
  get 'new'        => 'posts#new',       as: :new_post
  get ':slug'      => 'posts#show',      as: :show_post
  get ':slug/edit' => 'posts#edit',      as: :edit_post
  post ''          => 'posts#create',    as: :posts
end
