raw_config = File.read("#{Rails.root}/config/app_config.yml")
APP_CONFIG = YAML.load(raw_config)[Rails.env].symbolize_keys

MAIL_CONFIG = APP_CONFIG[:mail].symbolize_keys

ActionMailer::Base.smtp_settings = MAIL_CONFIG
