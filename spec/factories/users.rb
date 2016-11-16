FactoryGirl.define do
  factory :user, aliases: [:follower, :followed] do
    email { FFaker::Internet.email }
    password "12345678"
    password_confirmation "12345678"
    username { FFaker::Name.name }
    full_name { FFaker::Name.name }
    private false
  end
end
