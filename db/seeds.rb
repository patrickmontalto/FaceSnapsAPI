require 'factory_girl_rails'

def encode64(image)
  path = Rails.root.join('lib', 'seeds', image)
  photo = File.read(path)
  base64_encoded = Base64.encode64(photo)
  "data:image/jpg;base64,#{base64_encoded}"
end

# Create 3 seed users with profile photos
3.times do |n|
  n += 1
  photo_path = "profile_#{n}.jpg"
  base64_encoded = encode64(photo_path)
  user = FactoryGirl.create :user, { photo: base64_encoded}

  # Create posts for users
  case n
  when 1
    # create 1 post for user 1
    photo_path = "IMG_1.jpg"
    base64_encoded = encode64(photo_path)
    FactoryGirl.create :post, { photo: base64_encoded, user: user}
  when 2
    # create 4 posts for user 2
    4.times do |i|
      i += 2 # offset by 2
      photo_path = "IMG_#{i}.jpg"
      base64_encoded = encode64(photo_path)
      FactoryGirl.create :post, { photo: base64_encoded, user: user}
    end
  when 3
    # create 11 posts for user 3
    11.times do |i|
      i += 6 # offset by 6
      photo_path = "IMG_#{i}.jpg"
      base64_encoded = encode64(photo_path)
      FactoryGirl.create :post, { photo: base64_encoded, user: user}
    end
  else
  end
end


