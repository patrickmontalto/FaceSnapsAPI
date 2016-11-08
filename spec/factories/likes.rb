FactoryGirl.define do
  factory :like do
    user { FactoryGirl.create :user } 
    post { FactoryGirl.create :post }
  end
end
