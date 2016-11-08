require 'spec_helper'

describe User do
  before { @user = FactoryGirl.build(:user) }

  subject { @user }

  it { should respond_to(:auth_token) }
  it { should respond_to(:username) }
  it { should respond_to(:liked_posts) }

  it { should validate_presence_of(:username) }
  it { should validate_uniqueness_of(:username).ignoring_case_sensitivity }
  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email).ignoring_case_sensitivity }
  it { should validate_confirmation_of(:password) }
  it { should allow_value('example@domain.com').for(:email) }

  it { should have_many(:posts) }

  # Test that the auth_token is unique
  it { should validate_uniqueness_of(:auth_token) }

  describe "#follow & #unfollow" do
    let(:other) { FactoryGirl.create(:user) }
    before do
      @user.save
    end

    context "when not following" do
       it "returns false for user folllowing other user" do
        expect(@user.following?(other)).to be false
      end

      it "follows another user" do
        @user.follow(other)
        expect(@user.following?(other)).to be true
      end
    end

    context "when following" do
      before do
        @user.follow(other)
      end

      it "returns true for user following other user" do
        expect(@user.following?(other)).to be true
      end

      it "unfollows another user" do
        @user.unfollow(other)
        expect(@user.following?(other)).to be false
      end
    end
  end

  describe "#followers" do
    let(:other) { FactoryGirl.create(:user) }

    before do
      @user.save
      other.save
      other.follow(@user)
    end

    it "includes a collection of followers" do
      expect(@user.followers.count).to eql 1
      expect(@user.followers.include?(other)).to be true
    end

  end

  describe "#posts association" do
    before do
      @user.save
      3.times { FactoryGirl.create :post, user: @user }
    end

    it "destroys the associated posts on self destruct" do
      posts = @user.posts
      @user.destroy
      posts.each do |post|
        expect(Post.find(post)).to raise_error ActiveRecord::RecordNotFound
      end
    end
  end

  describe "#generate_auth_token!" do
  	it "generates a unique token" do
  		Devise.stub(:friendly_token).and_return("auniquetoken1234")
  		@user.generate_auth_token!
  		expect(@user.auth_token).to eql "auniquetoken1234"
  	end

  	it "generates another token when one has already been taken" do
  		existing_user = FactoryGirl.create(:user, auth_token: "auniquetoken1234")
  		@user.generate_auth_token!
  		expect(@user.auth_token).not_to eql existing_user.auth_token
  	end
  end

  describe "#liked_posts" do
    before do
      @user.save
      3.times {FactoryGirl.create :like, {user: @user} }
    end

    it "returns the liked posts of the user" do
      expect(@user.liked_posts.count).to eql 3
    end
  end

  describe "#like" do
    before do
      @user.save
      @post = FactoryGirl.create :post
      @user.like(@post)
    end

    it "likes a post" do
      expect(@user.liked_posts.count).to eql 1
      expect(@user.liked_posts).to include(@post)
    end
  end

  describe "#unlike" do
    before do
      @user.save
      post = FactoryGirl.create :post
      @user.like(post)
      @user.unlike(post)
    end
    
    it "unlikes a post" do
      expect(@user.liked_posts.count).to eql 0
    end
  end

end