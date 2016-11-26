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
	      @test_data = [{:id=>"4bdd46e14ffaa59350276ff7", :name=>"J.Co Donuts & Coffee", :lat=>40.703917, :lng=>-74.004673}, 
	      					   {:id=>"4e4dd631bd4101d0d79c5ed3", :name=>"Dunkin' Donuts", :lat=>40.707857980915406, :lng=>-74.00186944936608}, 
	      						 {:id=>"51ed7f8d498e595e275f31f4", :name=>"Hot Fresh Donuts", :lat=>40.70403030125524, :lng=>-74.00770549769048}]
	      allow_any_instance_of(FourSquareClient).to receive(:get_venues).and_return(@test_data)
	    end

	    it "returns a list of locations for a given query" do
	    	get :search, :lat => 40.7, :lng => -74, :query => 'donuts'

	    	expect(json_response[:data].first).to eql @test_data.first
	    	expect(json_response[:data].count).to eql 3
	    end

		end
	end
end
