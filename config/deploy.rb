# config valid for current version and patch releases of Capistrano
lock "~> 3.11.0"

set :application, 'chat-space'
set :repo_url,  'git@github.com:yuki122/chat-space.git'

set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'public/uploads')

set :rbenv_type, :user
set :rbenv_ruby, '2.3.1'

set :ssh_options, auth_methods: ['publickey'],
                  keys: ['~/.ssh/div-rails-tokyo.pem']

set :unicorn_pid, -> { "#{shared_path}/tmp/pids/unicorn.pid" }
set :unicorn_config_path, -> { "#{current_path}/config/unicorn.rb" }
set :keep_releases, 5

# 用いる環境変数を明示
set :default_env, {
  rbenv_root: "/usr/local/rbenv",
  path: "/usr/local/rbenv/shims:/usr/local/rbenv/bin:$PATH",
  AWS_ACCESS_KEY_ID: ENV["AWS_ACCESS_KEY_ID"],
  AWS_SECRET_ACCESS_KEY: ENV["AWS_SECRET_ACCESS_KEY"]
}

# 安全のためgitignoreしたconfig/secrets.ymlをdeployの時だけ直アップロード
# secrets.yml用のシンボリックリンクを追加
set :linked_files, %w{ config/secrets.yml }

# 元々記述されていた after 「'deploy:publishing', 'deploy:restart'」以下を削除して、次のように書き換え

after 'deploy:publishing', 'deploy:restart'
namespace :deploy do
  # task :restart do
  #   invoke 'unicorn:restart'
  # end
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      invoke 'unicorn:stop'
      invoke 'unicorn:start'
    end
  end

  desc 'upload secrets.yml'
  task :upload do
    on roles(:app) do |host|
      if test "[ ! -d #{shared_path}/config ]"
        execute "mkdir -p #{shared_path}/config"
      end
      upload!('config/secrets.yml', "#{shared_path}/config/secrets.yml")
    end
  end
  before :starting, 'deploy:upload'
  after :finishing, 'deploy:cleanup'
end

# after 'deploy:publishing', 'deploy:restart'
# namespace :deploy do
#   task :restart do
#     invoke 'unicorn:restart'
#   end
# end
