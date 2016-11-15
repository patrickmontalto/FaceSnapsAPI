require 'spec_helper'

describe Api::V1::CommentsController do
  describe 'GET #index' do
    context 'when signed in' do
      before(:each) do
        @user = FactoryGirl.create :user
        api_authorization_header @user.auth_token
        @post = FactoryGirl.create :post
        3.times { FactoryGirl.create :comment, { post: @post }}
        @last_comment = FactoryGirl.create :comment, { post: @post }
      end

      it "gets a list of comments on a post object in reverse order" do
        get :index, { post_id: @post.id }
        expect(json_response[:comments].count).to eql 4
        expect(json_response[:comments].first[:id]).to eql @last_comment.id
      end
    end
  end

  describe 'POST #create' do
    context 'when signed in' do
      before(:each) do
        @user = FactoryGirl.create :user
        api_authorization_header @user.auth_token
        @post = FactoryGirl.create :post
      end

      it "creates a comment on a post object" do
        post :create, { post_id: @post.id, text: 'This is a test comment.' }
        expect(@post.comments.count).to eql 1
        expect(json_response[:meta][:code]).to eql 200
      end

      it 'prevents comments on an unfollowed private users posts' do
        other_user = FactoryGirl.create :user, { private: true }
        private_post = FactoryGirl.create :post, { user: other_user }

        post :create, { post_id: private_post.id, text: 'This should not be allowed.' }

        expect(json_response[:errors]).to eql "Unable to comment on post"
      end

    end
  end

  describe 'DELETE #destroy' do
    context 'when signed in' do
      before(:each) do
        @user = FactoryGirl.create :user
        api_authorization_header @user.auth_token
        @post = FactoryGirl.create :post
        @comment = FactoryGirl.create :comment, { user: @user, post: @post }
      end

      it 'removes a comment on a post object as the user' do
        delete :destroy, { post_id: @post.id, id: @comment.id }
        expect(@post.comments.count).to eql 0
        expect(json_response[:meta][:code]).to eql 200
      end

      it 'returns json error when attempting to destroy comment not authored by user' do
        other_comment = FactoryGirl.create :comment, { post: @post }
        delete :destroy, { post_id: @post.id, id: other_comment.id }
        expect(@post.comments.count).to eql 2
        expect(json_response[:errors]).to eql "Unable to destroy comment."
      end

    end
  end
end