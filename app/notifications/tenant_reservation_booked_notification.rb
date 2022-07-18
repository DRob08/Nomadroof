# To deliver this notification:
#
# TenantReservationBooked.with(post: @post).deliver_later(current_user)
# TenantReservationBooked.with(post: @post).deliver(current_user)

class TenantReservationBookedNotification < Noticed::Base
  # Add your delivery methods
  #
  deliver_by :database
  deliver_by :email, mailer: "NotificationMailer", method: :guest_booked

  param :reservation
end
