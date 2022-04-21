class ReservationChangeColumnType < ActiveRecord::Migration[6.1]
  def change
    change_column :reservations, :total, :float
    change_column :reservations, :price, :float
  end
end
