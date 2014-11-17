class ConfigPolicy < Struct.new(:user, :config)

  def index?
    true
  end
end