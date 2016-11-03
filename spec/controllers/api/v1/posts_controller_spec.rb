require 'spec_helper'

describe Api::V1::PostsController do
	describe "GET #show" do
		before(:each) do
			@post = FactoryGirl.create :post
			get :show, id: @post.id
		end

		it "rerturns the information about a reporter on a hash" do
			post_response = json_response
			expect(post_response[:caption]).to eql @post.caption
		end

		it { should respond_with 200 }

	end

  describe "GET #index" do
    before(:each) do
      4.times { FactoryGirl.create :post }
      get :index
    end

    it "returns 4 records from the database" do
      posts_response = json_response
      expect(posts_response.length).to eq(4)
    end

    it { should respond_with 200 }
  end

  describe "POST #create" do
    context "when is successfully created" do
      before(:each) do
        user = FactoryGirl.create :user
        @post_attributes = FactoryGirl.attributes_for :post
        api_authorization_header user.auth_token
        post :create, { user_id: user.id, post: @post_attributes }
      end

      it "renders the json representation for the product record just created" do
        post_response = json_response
        expect(post_response[:caption]).to eql @post_attributes[:caption]
      end

      it { should respond_with 201 }
    end

    context "when is not created" do
      before(:each) do
        user = FactoryGirl.create :user
        @invalid_post_attributes = { caption: "Testing..." }
        api_authorization_header user.auth_token
        post :create, { user_id: user.id, post: @invalid_post_attributes }
      end

      it "renders an errors json" do
        post_response = json_response
        expect(post_response).to have_key(:errors)
      end

      it "renders the json errors on why the post could not be created" do
        post_response = json_response
        expect(post_response[:errors][:photo]).to include "can't be blank"
      end

      it { should respond_with 422 }
    end
  end

  describe "PUT/PATCH #update" do
    before(:each) do
      @user = FactoryGirl.create :user
      @post = FactoryGirl.create :post, user: @user
      api_authorization_header @user.auth_token
    end

    context "when is successfully updated" do
      before(:each) do
        patch :update, { user_id: @user.id, id: @post.id,
               post: { caption: "This is a new caption." } }
      end

      it "renders the json representation for the updated post" do
        post_response = json_response
        expect(post_response[:caption]).to eql "This is a new caption."
      end

      it { should respond_with 200 }
    end

    context "when is not updated" do
      before(:each) do
        patch :update, { user_id: @user.id, id: @post.id,
               post: { caption: nil } }
      end

      it "renders an errors json" do
        post_response = json_response
        expect(post_response).to have_key(:errors)
      end

      it "renders the json errors on why the post could not be created" do
        post_response = json_response
        expect(post_response[:errors][:caption]).to include "can't be blank"
      end

      it { should respond_with 422 }
    end
  end
end

