# Configure airbrake/errbit error reporting
PragueServer::Application.configure do
  config.airbrake = {
    enabled: ENV['AIRBRAKE_API_KEY'].present?,
    javascript_enabled: false,
    api_key: ENV['AIRBRAKE_API_KEY'],
    project_id: ENV['AIRBRAKE_PROJECT_ID'] || '',
  }
end

if Rails.configuration.airbrake[:enabled]
  Airbrake.configure do |config|
    config.api_key = Rails.configuration.airbrake[:api_key]
    # Aibrake doesn't expect URL scheme to be present on host
    config.host    = Rails.configuration.airbrake[:host].gsub(/(^http.*:)\/\//i, '') if Rails.configuration.airbrake[:host].present?
    config.port    = Rails.configuration.airbrake[:port]
    config.project_id  = Rails.configuration.airbrake[:project_id] if Rails.configuration.airbrake[:project_id].present?
    config.secure  = config.port == 443
  end
else
  # Ignore current environment and thereby disable Airbrake
  Airbrake.configure do |config|
    config.development_environments = [Rails.env]
  end
end
