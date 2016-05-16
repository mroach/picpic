class AddGeneratedToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :generated, :boolean, null: false, default: false
  end
end
