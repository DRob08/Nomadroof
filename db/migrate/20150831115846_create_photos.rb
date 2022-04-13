class CreatePhotos < ActiveRecord::Migration[6.1]
  def change
    create_table :photos do |t|
      t.references :room, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
