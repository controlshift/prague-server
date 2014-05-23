class Org::OrgController < ApplicationController
  before_filter :authenticate_organization!
end
