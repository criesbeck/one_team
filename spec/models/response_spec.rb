require 'spec_helper'

describe Response do

  before { @response = FactoryGirl.create(:response) }
  subject { @response }

  it { should respond_to(:request) }
  it { should respond_to(:user) }

  it {should be_valid}
end
