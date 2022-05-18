class Reservation < ActiveRecord::Base
  #enum :booking_status, [ :pending, :canceled, :accepted, :paid, :paypal_executed ]
  enum booking_status: {
    pending: 0,
    canceled: 1,
    accepted: 2,
    paid: 3,
  }
  belongs_to :user
  belongs_to :room

  def set_accepted
    self.booking_status = Reservation.booking_statuses[:accepted]
  end

  def set_cancel
    self.booking_status = Reservation.booking_statuses[:canceled]
  end

  def set_paid
    self.booking_status = Reservation.booking_statuses[:paid]
  end
end
