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
end
