FactoryGirl.define do
  factory :tag do
    name { FFaker::Lorem.word }
  end
end
