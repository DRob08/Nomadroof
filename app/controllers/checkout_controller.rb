class CheckoutController < ApplicationController

  def create
    logger.debug "PARAM: #{params[:reservation_id]}"
		@reservation = Reservation.find(params[:reservation_id])

		logger.debug "Reservation ID: #{@reservation.room_id}"
		@room = Room.find(@reservation.room_id)
		logger.debug "Room ID: #{@room.listing_name}"

		@session_stripe = Stripe::Checkout::Session.create({
     payment_method_types: ['card'],
     metadata: {
        reservation_id: @reservation.id,
        property_id: @reservation.room_id,
        owner_id: @reservation.owner_id,
        user_id: @reservation.user_id,
        user_email: current_user.email
     },
     customer_email: current_user.email,
		 line_items: [{
			 price_data: {
				 currency: 'usd',
				 product_data: {
					 name: @room.listing_name,
				 },
				 unit_amount: (@reservation.total * 100).to_i,
			 },
			 quantity: 1,
		 }],
		 mode: 'payment',
		 # These placeholder URLs will be replaced in a following step.
		 success_url: root_url,
		 cancel_url:  root_url,
	 })
	 respond_to do |format|
		  format.js
	 end
	end

end
