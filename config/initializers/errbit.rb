if defined? Airbrake
   Airbrake.configure do |config|
      config.api_key   = '9aa668deae35de618a056e7801da5329'
      config.host   = 'errbit.icfdev.ru'
      config.port   = 80
      config.secure = config.port == 443
   end

   require 'airbrake_wrapper'
end
