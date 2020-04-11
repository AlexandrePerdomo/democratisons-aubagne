Rails.application.routes.draw do
  root "pages#home"
  get '/election-municipale-2020', to: "elections#index"
  get '/election-municipale-2020/:name', to: "elections#show"
  get '/doleances', to: "pages#doleances"
  get '/mentions-legales', to: "pages#cgu"

  # Gestion des utilisateurs
  # Demande de mail confirmation, post vers api
  get '/confirmer-mon-compte', to: 'confirmations#new'
  resources :confirmations, only: [:create]
  # Mot de passe oublie
  get '/mot-de-passe-oublie', to: 'passwords#new'
  post '/mot-de-passe-oublie', to: 'passwords#create', as: 'passwords'
  get '/modifier-mon-mot-de-passe', to: 'passwords#edit'
  post '/modifier-mon-mot-de-passe', to: 'passwords#update', as: 'password'
  # Page de creation, post vers api, page edit, update vers api, 
  # show profil, suppression (anonymisation) du profil
  get '/inscription', to: "registrations#new"
  post '/inscription', to: "registrations#create", as: "registrations"
  # get '/modifier-mon-compte', to: "registrations#edit"
  # post '/modifier-mon-compte', to: "registrations#update", as: "registration"
  get '/mon-compte', to: "registrations#show"
  get '/supprimer-mon-compte', to: "registrations#destroy"
  # Page de login, post vers api, lien de suppression de session
  get '/connexion', to: "sessions#new"
  post '/connexion', to: "sessions#create", as: "sessions"
  get '/deconnexion', to: "sessions#destroy"
  # Gestion des invitations
  get '/invitation', to: "invitations#new"
  post '/invitation', to: "invitations#create", as: "invitations"

  resources :consultations, only: [:index, :show]
  resources :structures, only: [:index, :show]
  post '/structures/:id', to: 'structures#invitation', as: "structure_invitation"
  post '/consultations/:id', to: 'consultations#submit_vote', as: "submit_vote"
end
