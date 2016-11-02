FactoryGirl.define do
  factory :post do
    caption "I am #grateful and #awesome! #Rails, ftw."
    user
    photo "data:image/jpg;base64,#{Base64.encode64(File.read('jazzmaster.jpg'))}"
  end
end
