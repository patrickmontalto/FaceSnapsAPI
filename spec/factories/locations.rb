FactoryGirl.define do
  factory :location do
  	venue_id { SecureRandom.urlsafe_base64(12) }
    latitude { FFaker::Geolocation.lat }
    longitude { FFaker::Geolocation.lng }
    name { FFaker::AddressCHDE.street_name }
  end
end
