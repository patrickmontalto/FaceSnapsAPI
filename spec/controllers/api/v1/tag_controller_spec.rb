require 'spec_helper'

describe Api::V1::TagsController do

  describe 'GET #show' do
    context 'when signed in' do
      before(:each) do
        @user = FactoryGirl.create :user
        api_authorization_header @user.auth_token

        tag = FactoryGirl.create :tag, { name: "vacation2016" }
        3.times do
          post = FactoryGirl.create :post
          tag.taggings.create(taggable: post)
        end
      end

      it "returns information about the tag" do
        get :show, :tag_name => "vacation2016"

        expect(json_response[:data][:post_count]).to eql 3
        expect(json_response[:data][:name]).to eql "vacation2016"
      end
    end
  end

  describe 'GET #posts' do
    context 'when signed in' do
      before(:each) do
        @user = FactoryGirl.create :user
        api_authorization_header @user.auth_token

        tag = FactoryGirl.create :tag, { name: "vacation2016" }
        22.times do
          post = FactoryGirl.create :post, { caption: "this is from #vacation2016" }
          tag.taggings.create(taggable: post)
        end
      end

      it "returns a paginated list of posts with the designated tag" do
        get :posts, :tag_name => "vacation2016"

        expect(json_response[:posts].count).to eql 20
        expect(response['Total']).to eql "22"
      end

    end
  end

  describe 'GET #search' do
    context 'when signed in' do
      before(:each) do
        @user = FactoryGirl.create :user
        api_authorization_header @user.auth_token


        snowy_tag = FactoryGirl.create :tag, { name: 'snowy' }
        2.times do
          post = FactoryGirl.create :post
          snowy_tag.taggings.create(taggable: post)
        end
        snowday_tag = FactoryGirl.create :tag, { name: 'snowyday' }
        snowymountains_tag = FactoryGirl.create :tag, { name: 'snowymountains' }
      end

      it "returns a list of tags" do
        get :search, :query => 'snowy'

        expect(json_response[:tags].count).to eql 3
        expect(json_response[:tags][0][:name]).to eql "snowy"
        puts json_response
        expect(json_response[:tags][0][post_count]).to eql 2
      end

    end
  end
end
