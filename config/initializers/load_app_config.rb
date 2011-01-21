raw_config = File.read("#{Rails.root}/config/app_config.yml")
APP_CONFIG = YAML.load(raw_config)[Rails.env].symbolize_keys

MAIL_CONFIG = APP_CONFIG[:mail].symbolize_keys

ActionMailer::Base.smtp_settings = MAIL_CONFIG

if Rails.env=='production'
  Chebytoday::Application.configure do
    config.middleware.use "::ExceptionNotifier",
    :email_prefix => "[WebApp Error] ",
    :sender_address => MAIL_CONFIG[:sender], # %{"notifier" <notifier@chebytoday.ru>},
    :exception_recipients => MAIL_CONFIG[:recipient] #%w{danil@orionet.ru} 
  end
end
