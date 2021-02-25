Rails.application.routes.draw do
  post 'user/:id/payment', to: 'users#payment'
  get 'user/:id/balance', to: 'users#balance'
  get 'user/:id/feed', to: 'users#feed'
end
