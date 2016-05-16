require 'autoface/processor'

class PhotoUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Create different versions of the uploaded files:
  version :thumb do
    process :resize_to_fit => [200, 200]
  end

  version :tiny, from_version: :thumb do
    process :resize_to_fit => [80, 80]
  end


  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(jpg jpeg gif png)
  end

  def download_file_name
    File.basename(path)
  end

end
