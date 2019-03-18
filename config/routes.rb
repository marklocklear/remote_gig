Rails.application.routes.draw do
  get '/stats', :to => redirect('/nightly_stats.txt')
  resources :jobs do
  	collection do
  		post :email_signup
  	end
  end
  get '*tag', to: 'jobs#index'
  root to: 'jobs#index'
end
