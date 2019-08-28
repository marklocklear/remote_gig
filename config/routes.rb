Rails.application.routes.draw do
  devise_for :users
  resources :user_jobs do
    collection do
      post :save_to_my_jobs
    end
  end
  get '/stats', :to => redirect('/nightly_stats.txt')
  resources :jobs do
  	collection do
  		post :email_signup
  	end
  end
  get 'vetswhocode' => 'jobs#vetswhocode_json_feed'
  get '*tag', to: 'jobs#index'
  root to: 'jobs#index'
end
