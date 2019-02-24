require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ChatSpace
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # rails g controllerでの生成ファイルを作らないようにする
    config.generators do |g|
      g.stylesheets false
      g.javascripts false
      g.helper false
      g.test_framework false
    end

    # 日本語化
    config.i18n.default_locale = :ja
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.yml').to_s]

    config.action_view.field_error_proc = Proc.new { |html_tag, instance|
      # 投稿フォームの時だけ、例外的にdivタグをつけないようにする
      if instance.object.is_a?(Message) && !instance.object.persisted?
        # field_with_errorsを出力しない
        html_tag
      else
        # 通常はデフォルトの使用
        "<div class=\"field_with_errors\">#{html_tag}</div>".html_safe
      end
    }
  end
end
