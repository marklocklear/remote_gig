Rails.application.routes.draw do
  resources :jobs do
  	collection do
  		post :email_signup
  	end
  end

  root to: 'jobs#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
