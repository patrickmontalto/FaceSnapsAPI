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

  it "should default accepted to true if followed is not private" do
    expect(relationship.accepted).to be true
  end

  it "should set accepted to false if the followed is private" do
    user = FactoryGirl.create :user, { private: true }
    other = FactoryGirl.create :user
    private_relationship = Relationship.create(follower: other, followed: user)
    expect(private_relationship.accepted).to be false
  end

end
