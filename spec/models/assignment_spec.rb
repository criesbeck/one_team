require 'spec_helper'

describe Assignment do
  let(:response){FactoryGirl.create(:response)}
  let(:assignment){response.build_assignment(comment: "I choose you")}

  subject{ assignment }

  it { should be_valid }

  it {should respond_to(:response)}
  it {should respond_to(:request)}
  it {should respond_to(:user)}
end
