class ConfigController < ActionController::Metal

  def index
    hash = Organization.global_defaults_for_slug(params[:id])
    hash['country'] = country
    json = ActiveSupport::JSON.encode(hash)
    json = "#{params[:callback]}(#{json})" unless params[:callback].blank?
    self.content_type = 'application/javascript'
    self.response_body = json
  end

  private

  def country
    cc = GeoIP.new(ENV['GEOCOUNTRY_LITE_PATH']).country(request.remote_ip).country_code2
    if cc == '--'
      nil
    else
      cc
    end
  end
end