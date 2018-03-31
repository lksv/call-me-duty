if defined?(Bullet) && !Rails.env.production?
  Rails.application.configure do
    config.after_initialize do
      Bullet.enable = true

      Bullet.bullet_logger = true
      Bullet.console = true
      Bullet.alert = true
      Bullet.raise = Rails.env.test?
    end
  end
end
