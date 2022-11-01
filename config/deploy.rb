# config valid for current version and patch releases of Capistrano
lock "~> 3.17.1"

set :application, "qna"
set :repo_url, "git@github.com:bl1ndy/t-39-qna.git"

ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

set :deploy_to, "/home/deploy/#{fetch :application}"
set :pty, false

append :linked_files, 'config/database.yml', 'config/master.key'
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/uploads}

set :keep_releases, 3

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
end
