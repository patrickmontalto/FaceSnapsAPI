FactoryGirl.define do
  factory :tagging do
    tag { FactoryGirl.create :tag }
    taggable_id
    taggable_type
  end
end
