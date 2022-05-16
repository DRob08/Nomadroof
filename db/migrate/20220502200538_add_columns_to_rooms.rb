class AddColumnsToRooms < ActiveRecord::Migration[6.1]
  def change
    add_column :rooms, :city, :string
    add_column :rooms, :postal_code, :integer
    add_column :rooms, :country, :string
    add_column :rooms, :features, :json
  end
end
