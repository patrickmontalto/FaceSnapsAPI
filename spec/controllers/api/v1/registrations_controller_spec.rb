require 'spec_helper'

describe Api::V1::RegistrationsController do
  # Returns the user object upon sign up
  describe "POST #create" do

    context "with valid criteria" do
      it "returns the user object via json" do
        post :create, { user: {username: "test1234", password: "password1234", full_name: "Test Guy", email: "test@gmail.com"} }
        expect(json_response[:user][:full_name]).to eql "Test Guy"
      end
    end

    context "with invalid criteria" do
      it "returns an errors json" do
        post :create, { user: {username: "test1234", password: "password1234", full_name: "Test Guy"} }
        expect(json_response[:errors][:email]).to eql "can't be blank"
      end
    end

  end

  describe "POST #check_availability" do
    context "when not available" do
      it "returns the availability as false" do
        @user = FactoryGirl.create :user

        post :check_availability, { user_credential: @user.email }

        expect(json_response[:available]).to eql false
      end
    end

    context "when available" do
      it "returns the availability as true" do
        post :check_availability, { user_credential: "test_email@gmail.com" }

        expect(json_response[:available]).to eql true
      end
    end
  end
end