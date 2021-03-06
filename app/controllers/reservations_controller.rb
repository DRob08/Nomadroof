class ReservationsController < ApplicationController
	before_action :authenticate_user!, except: [:notify]

	def preload
		room = Room.find(params[:room_id])
		today = Date.today
		reservations = room.reservations.where("booking_status = ? AND (start_date >= ? OR end_date >= ?)", 3, today, today)
		render json: reservations
	end

	def preview
		start_date = Date.parse(params[:start_date])
		end_date = Date.parse(params[:end_date])

		output = {
			conflict: is_conflict(start_date, end_date)
		}

		render json: output
	end


	def create
		if !user_signed_in?
			redirect_to new_user_session_path
		else
			if current_user.phone_number.nil?
				redirect_to edit_user_registration_path, alert: "You need to fill out profile!"
			else
				@reservation = current_user.reservations.create(reservation_params)

				if @reservation
					# send request to PayPal
					values = {
						business: 'Darwin.Robinson8-facilitator@gmail.com',
						cmd: '_xclick',
						upload: 1,
						notify_url: 'http://22ee1588.ngrok.io/notify',
						amount: @reservation.total,
						item_name: @reservation.room.listing_name,
						item_number: @reservation.id,
						quantity: '1',
						return: 'http://22ee1588.ngrok.io/your_trips'
					}
					# redirect_to "https://www.sandbox.paypal.com/cgi-bin/webscr?" + values.to_query
					redirect_to your_trips_path
				else
					redirect_to @reservation.room, alert: "Oops, something went wrong..."
				end
			end
		end
	end

 def accept_reservation
	 @reservation = Reservation.find(params[:id])
	 if @reservation.present?
		 @reservation.set_accepted
		 @reservation.save
		 flash[:notice] = "Accepted Booking Request"
	 end
	 redirect_back(fallback_location: root_path)
 end

	def destroy
    @reservation = Reservation.find(params[:id])
    if @reservation.present?
      #@reservation.destroy
			#@reservation.booking_status = 'CANCELED'
			@reservation.set_cancel
			@reservation.save
			flash[:notice] = "Booking canceled"
    end
		redirect_back(fallback_location: root_path)
  end

	protect_from_forgery except: [:notify]
	def notify
		params.permit!
		status = params[:payment_status]
		reservation = Reservation.find(params[:item_number])

		if status == "Completed"
			reservation.update_attributes status: true
		else
			reservation.destroy
		end

		render nothing: true
	end

	protect_from_forgery except: [:your_trips]
	def your_trips
		#@trips = current_user.reservations.where("status = ?", true)
		#@trips = current_user.reservations.where.not(booking_status: 'CANCELED')
		@trips = current_user.reservations.order(created_at: :desc)
	end

	def your_reservations
		@rooms = current_user.rooms.order(created_at: :desc)
	end

	private
		def is_conflict(start_date, end_date)
			room = Room.find(params[:room_id])

			check = room.reservations.where("? < start_date AND end_date < ?", start_date, end_date)
			check.size > 0? true : false
		end

		def reservation_params
			params.require(:reservation).permit(:start_date, :end_date, :price, :total, :room_id, :owner_id, :booking_status, :total_months, :service_fee)
		end
end
