class ChangeBookingStatusToBeIntegerInReservations < ActiveRecord::Migration[6.1]
  def change
    change_column :reservations, :booking_status, :integer
  end
end
