FactoryGirl.define do
  factory :tagging do
    tag { FactoryGirl.create :tag }
    association :taggable, factory: :post
  end
end
