class AddColumnsToReservation < ActiveRecord::Migration[6.1]
  def change
    add_column :reservations, :booking_status, :string
    add_column :reservations, :owner_id, :integer
    add_column :reservations, :total_months, :float
    add_column :reservations, :service_fee, :float
  end
end
