class ConfigController < ActionController::Metal

  def index
    hash = Organization.global_defaults_for_slug(params[:id])
    hash['country'] = geoip_country || hash['country'] || 'US'
    json = ActiveSupport::JSON.encode(hash)
    json = "#{params[:callback]}(#{json})" unless params[:callback].blank?
    self.content_type = 'application/javascript'
    self.response_body = json
  end

  private

  def geoip_country
    begin
      Timeout::timeout(3) do
        cc = GeoIP.new(ENV['GEOCOUNTRY_LITE_PATH']).country(request.remote_ip).country_code2
        if cc == '--'
          nil
        else
          cc
        end
      end
    rescue Timeout::Error
      Rails.logger.warn "GeoIP timed out!"
      return nil
    end
  end
end