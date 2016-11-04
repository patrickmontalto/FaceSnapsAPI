class PhotoUploader < CarrierWave::Uploader::Base
  def filename
     "#{secure_token(10)}.#{file.extension}" if original_filename.present?
  end

  # Override the dir where the uploaded photos will be stored.
  def store_dir
  	"uploads/#{Rails.env}/photos"
  end

  protected
  def secure_token(length=16)
    var = :"@#{mounted_as}_secure_token"
    model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.hex(length/2))
  end
end