require 'spec_helper'

describe Relationship do
  let(:relationship) { FactoryGirl.build :relationship }
  subject { relationship }

  it { should be_valid }

  it "should require a follower_id" do
    relationship.follower_id = nil
    expect(relationship).to_not be_valid
  end

  it "should require a followed_id" do
    relationship.followed_id = nil
    expect(relationship).to_not be_valid
  end

end
