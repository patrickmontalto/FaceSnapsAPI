FactoryGirl.define do
  factory :relationship do
    association :follower
    association :followed
    accepted true
  end
end
