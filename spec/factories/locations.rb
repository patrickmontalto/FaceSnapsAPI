FactoryGirl.define do
  factory :location do
    latitude { FFaker::Geolocation.lat }
    longitude { FFaker::Geolocation.lng }
    name { FFaker::AddressCHDE.street_name }
  end
end
