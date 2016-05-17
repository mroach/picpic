class Photo < ActiveRecord::Base
  mount_uploader :file, PhotoUploader

  def self.visible
    where(archived: false)
  end
end
