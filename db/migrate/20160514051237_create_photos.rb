class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.string :description
      t.datetime :taken_at
      t.integer :owner_person_id
      t.text :comments

      t.timestamps null: false
    end

    add_index :photos, :owner_person_id
    add_foreign_key :photos, :people, column: :owner_person_id
  end
end
