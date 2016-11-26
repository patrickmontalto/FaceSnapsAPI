require 'spec_helper'

describe Api::V1::LocationsController do
	describe 'GET #show' do
		context 'when signed in' do
			before(:each) do
	      @user = FactoryGirl.create :user
	      @location = FactoryGirl.create :location
	      api_authorization_header @user.auth_token
	    end

	    it 'returns information about the location' do
	    	get :show, :venue_id => @location.venue_id

	    	expect(json_response[:data][:venue_id]).to eql @location.venue_id
	    	expect(json_response[:data][:name]).to eql @location.name
	    	expect(json_response[:data][:lat]).to eql "#{@location.latitude.to_f}"
	    	expect(json_response[:data][:lng]).to eql "#{@location.longitude.to_f.to_s}"
	    end

		end
	end

	describe 'GET #posts' do
		context 'when signed in' do
			before(:each) do
	      @user = FactoryGirl.create :user
	      api_authorization_header @user.auth_token
	      @location = FactoryGirl.create :location
	      posts = []
	      22.times do
	      	post = FactoryGirl.create :post
	      	posts.append(post)
	      end
	      allow_any_instance_of(Location).to receive(:posts).and_return(posts)
	    end

	    it "returns a paginated list of posts for a given location" do
	    	get :posts, :venue_id => @location.venue_id

	    	expect(json_response[:data][:posts].count).to eql(20)
        expect(response['Total']).to eql "22"
	    end

		end
	end

	describe 'GET #search' do
		context 'when signed in' do
			before(:each) do
	      @user = FactoryGirl.create :user
	      api_authorization_header @user.auth_token
	    end

	    it "returns a list of locations for a given query" do
	    end


		end
	end
end
