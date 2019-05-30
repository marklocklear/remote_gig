Rails.application.routes.draw do
  get '/stats', :to => redirect('/nightly_stats.txt')
  resources :jobs do
  	collection do
  		post :email_signup
  	end
  end
  get 'vetswhocode' => 'jobs#vetswhocode_json_feed'
  post 'add_to_favorites', to: 'jobs#add_to_favorites'
  get '*tag', to: 'jobs#index'
  root to: 'jobs#index'
end
