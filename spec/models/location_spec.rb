require 'spec_helper'

describe Location do
  let(:location) { FactoryGirl.build :location }
  subject { location }

  it { should respond_to(:latitude) }
  it { should respond_to(:longitude) }
  it { should respond_to(:name) }
  it { should respond_to(:posts) }

  it { should validate_presence_of :latitude }
  it { should validate_presence_of :longitude }
  it { should validate_presence_of :name }

end