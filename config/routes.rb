Rails.application.routes.draw do
  # devise_for :users
  # devise_for :users, :controllers => { :registrations => "my_registrations" }
  devise_for :users, controllers: { registrations: 'users/registrations' }

  resources :user_jobs do
    collection do
      get :archive_job
      get :un_archive_job
      get :get_archived_jobs
    end
  end
  get '/stats', :to => redirect('/nightly_stats.txt')
  resources :jobs do
  	collection do
  		# post :email_signup
      # post :email_job
  	end
  end
  get 'myjobs' => 'user_jobs#index'
  get 'vetswhocode' => 'jobs#vetswhocode_json_feed'
  get '*tag', to: 'jobs#index'
  root to: 'jobs#index'
end
