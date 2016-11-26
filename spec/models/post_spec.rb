require 'spec_helper'

describe Post do
  let(:post) { FactoryGirl.build :post }
  subject { post} 

  it { should respond_to(:caption) }
  it { should respond_to(:user_id) }
  it { should respond_to(:tags) }
  it { should respond_to(:photo) }
  it { should respond_to(:likes) }
  it { should respond_to(:location) }

  it { should validate_presence_of :caption }
  it { should validate_presence_of :user_id }
  it { should belong_to :user }

  it "should not allow Post with no photo file" do
    bad_post = FactoryGirl.build(:post, photo: nil)
    expect(bad_post).to be_invalid
  end


  describe "#tags" do
    it "returns an array of hashtags" do
      post.run_callbacks(:commit)
      expect(post.tags.count).to eql 3
    end
  end

  describe "#like_count" do
    before do
      @post = FactoryGirl.create :post
       3.times do
        FactoryGirl.create :like, { post: @post }
      end
    end
   
    it "returns the number of likes it currently has" do
      expect(@post.like_count).to eql 3
    end
  end

  describe '#public' do
    before do
      user = FactoryGirl.create :user, { private: true }
      FactoryGirl.create :post, {user: user }
      2.times { FactoryGirl.create :post }
    end

    it "returns only public posts" do
      expect(Post.public.count).to eql 2
    end
  end

  describe '#save_with_location' do
    before(:each) do
      @post = FactoryGirl.build :post
      @location = {:id=>"4bdd46e14ffaa59350276ff7", :name=>"J.Co Donuts & Coffee", :lat=>40.703917, :lng=>-74.004673}
    end

    context "when the location already exists in the datbase" do
      before do
        Location.create(:venue_id => @location[:id], 
                        :name => @location[:name], 
                        :latitude => @location[:lat], 
                        :longitude => @location[:lng])
      end
      it "saves only the association" do
        @post.save_with_location(@location)

        expect(@post.location.name).to eql @location[:name]
        expect(Location.count).to eql 1
      end
    end

    context "when the location does not exist in the database" do
      it "creates a new location entry and saves the association" do
        @post.save_with_location(@location)

        expect(@post.location.name).to eql @location[:name]
        expect(Location.count).to eql 1      end
    end
  end

  describe "#set_tags" do
    it "creates taggings for tags on post" do
      post = FactoryGirl.create :post, { caption: "#amazing post right here. #testing" }
      post.run_callbacks(:commit)
      user = FactoryGirl.create :user

      amazing_tag = Tag.find_by(name: "amazing")

      expect(post.tags.count).to eql 2
      expect(amazing_tag.visible_posts(user)).to include post

    end
  end

end
