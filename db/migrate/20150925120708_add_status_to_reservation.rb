class AddStatusToReservation < ActiveRecord::Migration[6.1]
  def change
    add_column :reservations, :status, :boolean
  end
end
