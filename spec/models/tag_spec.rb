require 'spec_helper'

describe Tag do
  let(:tag) { FactoryGirl.build :tag }
  subject { tag }

  it { should respond_to(:name) }
  it { should respond_to(:posts) }
  it { should respond_to(:visible_posts) }

  it { should validate_presence_of :name }

  it "should return a list of visible posts" do
    awesome_tag = FactoryGirl.create :tag, { name: "awesome" }
    post1 = FactoryGirl.create :post, { caption: "#awesome stuff"}
    post2 = FactoryGirl.create :post, { caption: "this is #awesome #great" }
    FactoryGirl.create :tagging, { tag: awesome_tag, taggable_id: post1.id, taggable_type: 'Post' }
    FactoryGirl.create :tagging, { tag: awesome_tag, taggable_id: post2.id, taggable_type: 'Post' }

    expect(awesome_tag.visible_posts.count).to eql 2
  end
end
