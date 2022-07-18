# To deliver this notification:
#
# HostReservationBooked.with(post: @post).deliver_later(current_user)
# HostReservationBooked.with(post: @post).deliver(current_user)

class HostReservationBookedNotification < Noticed::Base
  # Add your delivery methods
  #
  deliver_by :database
  deliver_by :email, mailer: "NotificationMailer", method: :host_booked

  param :reservation

  def message
    #params[:message].content
  end

  def url
    reservation_path(params[:reservation])
  end
end
