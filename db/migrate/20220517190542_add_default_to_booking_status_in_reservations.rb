class AddDefaultToBookingStatusInReservations < ActiveRecord::Migration[6.1]
  def change
    change_column :reservations, :booking_status, :integer , :default => 0
  end
end
