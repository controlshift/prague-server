require 'spec_helper'

describe Charge do
  it { should validate_presence_of :amount }
  it { should validate_presence_of :currency }
end
