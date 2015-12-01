# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Precompile additional assets.
# application.js, application.css.scss, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
Rails.application.config.assets.precompile += %w( swagger_engine/reset.css )
Rails.application.config.assets.precompile += %w( swagger_engine/print.css )
Rails.application.config.assets.precompile += %w( dashboard/dashboard.js )
Rails.application.config.assets.precompile += %w( dashboard/pusher/pusher.js )
