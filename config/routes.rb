Rails.application.routes.draw do
  post 'user/:id/payment', to: 'users#payment'
end
