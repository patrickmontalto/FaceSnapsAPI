module Base64encodable
  extend ActiveSupport::Concern

  def base64_image
    if self.photo
      url = "#{Rails.root}/public#{self.photo.url}"
      image = File.read(url)
      encoded64 = Base64.encode64(image)
      "data:image/jpg;base64,#{encoded64}"
    end
  end
end