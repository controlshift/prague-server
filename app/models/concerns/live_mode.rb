module LiveMode
  extend ActiveSupport::Concern

  included do
    scope :live, -> { where(status: 'live') }
    scope :test, -> { where(status: 'test') }
  end

  def live?
    status == 'live'
  end

  def test?
    status == 'test'
  end
end