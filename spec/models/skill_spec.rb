require 'spec_helper'

describe Skill do
  it { should respond_to(:requests) }
  it { should respond_to(:relevant_skills) }
  it { should respond_to(:users) }
  it { should respond_to(:desired_skills) }
  it { should respond_to(:current_skills) }
end
