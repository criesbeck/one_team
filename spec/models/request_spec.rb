require 'spec_helper'

describe Request do

  before { @request = FactoryGirl.create(:request) }
  subject { @request }

  it { should respond_to(:user_id) }
  it { should respond_to(:title) }
  it { should respond_to(:description) }
  it { should respond_to(:start_date) }
  it { should respond_to(:end_date) }
  it { should respond_to(:group_name) }
  it { should respond_to(:office_name) }
  it { should respond_to(:date_completed) }
  it { should respond_to(:date_cancelled) }

  it { should respond_to(:group) }
  it { should respond_to(:location) }
  it { should respond_to(:relevant_skills) }
  it { should respond_to(:responses) }

  it { should be_valid }

  describe "with a blank title" do
    before { @request.title = " " }
    it { should_not be_valid }
  end

  describe "with a start_date after the end_date" do
    before { @request.start_date = @request.end_date + 1.day}
    it {should_not be_valid}
  end

  describe "with an end_date before the start_date" do
    before { @request.end_date = @request.start_date - 1.day}
    it {should_not be_valid}
  end
end
