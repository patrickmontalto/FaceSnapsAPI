FactoryGirl.define do
  factory :comment do
    user { FactoryGirl.create :user }
    post { FactoryGirl.create :post }
    text "Test"
  end
end
