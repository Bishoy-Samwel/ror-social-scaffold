Rails.application.routes.draw do

  root 'posts#index'

  devise_for :users

  resources :users, only: [:index, :show] do
    post 'request', to:'users#send_request'
    put '/approve/:sender_id', to: 'users#confirm_request'
    delete '/reject/:sender_id', to: 'users#reject_request'
  end
  resources :posts, only: [:index, :create] do
    resources :comments, only: [:create]
    resources :likes, only: [:create, :destroy]
  end

  get "getPosts", to: "api#posts_index"
  get "comments/:post_id", to: "api#show_comments"
  post "comments/add/:user_id/:post_id/:content", to: "api#create_comment"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
