Rails.application.routes.draw do
  post 'user/:id/payment', to: 'users#payment'
  get 'user/:id/balance', to: 'users#balance'
end
