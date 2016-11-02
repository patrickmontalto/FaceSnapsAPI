require 'spec_helper'

describe Post do
  let(:post) { FactoryGirl.build :post }
  subject { post} 

  it { should respond_to(:caption) }
  it { should respond_to(:user_id) }
  it { should respond_to(:tags) }
  it { should respond_to(:photo) }

  it { should validate_presence_of :caption }
  it { should validate_presence_of :user_id }
  it { should validate_presence_of :photo }

  describe "#tags" do
    it "returns an array of hashtags" do
      expect(post.tags).to eql %w(grateful awesome rails)
    end
  end

end
