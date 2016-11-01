require 'spec_helper'

describe Post do
  let(:post) { FactoryGirl.build :post }
  subject { post} 

  it { should respond_to(:caption) }
  it { should respond_to(:user) }
  it { should respond_to(:tags) }

  describe "#tags" do
    it "returns an array of hashtags" do
      expect post.tags.to eql %w(grateful awesome rails)
    end
  end

end
