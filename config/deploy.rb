set :application, 'remotegig'
set :repo_url, 'git@github.com:marklocklear/remote_gig.git'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

set :deploy_to, '/home/deployer/remotegig'
set :scm, :git
set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml', '.env')
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')
set :keep_releases, 5
set :rvm_type, :user
set :rvm_ruby_version, '2.6.4' 

before "deploy:assets:precompile", "deploy:yarn_install"

namespace :deploy do

	desc 'Run rake yarn:install'
  task :yarn_install do
    on roles(:web) do
      within release_path do
        execute("cd #{release_path} && yarn install")
      end
    end
  end

  after :publishing, 'deploy:restart'
  after :finishing, 'deploy:cleanup'
end