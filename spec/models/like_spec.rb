require 'spec_helper'

describe Like do
  let(:like) { FactoryGirl.build :like }
  subject { like }

  it { should respond_to(:post) }
  it { should respond_to(:user) }

  it { should validate_presence_of :user }
  it { should validate_presence_of :post }
end
