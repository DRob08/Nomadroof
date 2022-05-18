Rails.application.routes.draw do

  resources :amenities
  resources :roles
  resources :user_steps
  root 'pages#home'

  devise_for 	:users,
  						:path => '',
  						:path_names => {:sign_in => 'login', :sign_out => 'logout', :edit => 'profile'},
  						:controllers => {:omniauth_callbacks => 'omniauth_callbacks',
  														 :registrations => 'registrations'
  														}
  # scope '/admin' do
  #   resources :users
  # end

  resources :users, only: [:show]
  resources :rooms
  resources :photos

  resources :rooms do
    resources :reservations, only: [:create, :destroy]
  end

  resources :conversations, only: [:index, :create] do
    resources :messages, only: [:index, :create]
  end

  resources :rooms do
    resources :reviews, only: [:create, :destroy]
  end

  get '/preload' => 'reservations#preload'
  get '/preview' => 'reservations#preview'

  get '/your_trips' => 'reservations#your_trips'
  get '/your_reservations' => 'reservations#your_reservations'

  post '/notify' => 'reservations#notify'
  post '/your_trips' => 'reservations#your_trips'

  get '/search' => 'pages#search'

  put "/reservations/:id", to: "reservations#accept_reservation", as: :accept_booking

  delete '/reservations/:id' => 'reservations#destroy' , as: :delete_reservation

end
