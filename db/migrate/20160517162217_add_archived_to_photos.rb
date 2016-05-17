class AddArchivedToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :archived, :boolean, default: false, null: false
  end
end
