# Be sure to restart your server when you modify this file.

# ActiveSupport::Reloader.to_prepare do
#   ApplicationController.renderer.defaults.merge!(
#     http_host: 'example.org',
#     https: false
#   )
# end

# RuntimeError、attachment、refileを使った時に出るエラー、refileシークレットキーをコピーしてペースト、保存して、サーバー再起動、そうすると、プロフィールの文章も画像もアップデートされる
Refile.secret_key = '43e5b6571e84f8f3f809fbb161775cd90ae094678fa6f80f6a50de4ce3e51bac8aecc0183926f24bc3852d86c7bc539c7f26373c259fa9ea2dc83adced6bca94'
