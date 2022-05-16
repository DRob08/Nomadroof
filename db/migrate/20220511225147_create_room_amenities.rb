class CreateRoomAmenities < ActiveRecord::Migration[6.1]
  def change
    create_table :room_amenities do |t|
      t.references :room, foreign_key: true
      t.references :amenity, foreign_key: true
      t.string :description

      t.timestamps
    end
  end
end
