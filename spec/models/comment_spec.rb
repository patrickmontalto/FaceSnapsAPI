require 'spec_helper'

describe Comment do
  let(:comment) { FactoryGirl.build :comment }
  subject { comment }

  it { should respond_to(:post) }
  it { should respond_to(:user) }

  it { should validate_presence_of :user }
  it { should validate_presence_of :post }
  it { should validate_presence_of :text }

end