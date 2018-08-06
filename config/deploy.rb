set :application, 'remotegig'
set :repo_url, 'git@github.com:marklocklear/remote_gig.git'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

set :deploy_to, '/home/deployer/remotegig'
set :scm, :git
set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')
set :keep_releases, 5
set :rvm_type, :user

namespace :deploy do

  # Not needed if using capistrano-passenger gem/recipe
  # desc 'Restart application'
  # task :restart do
  #   on roles(:app), in: :sequence, wait: 5 do
  #     execute :touch, release_path.join('tmp/restart.txt')
  #   end
  # end

  after :publishing, 'deploy:restart'
  after :finishing, 'deploy:cleanup'
end