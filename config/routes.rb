Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resource :user, only: [:create]
  post "/login", to: "user#login"
  get "/login/validate", to: "user#jwt_validate"
end
