class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    payload = request.body.read
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']
    logger.debug "Sig header = #{sig_header}"
    event = nil
    endpoint_secret = 'whsec_cb96809dfb811dae74258b4405895a9d50793398cb47bedd392eb47693167bcb'

    begin
      event = Stripe::Webhook.construct_event(
            payload, sig_header, endpoint_secret
        )
    rescue JSON::ParserError => e
      # Invalid payload
      render json: {message: 'failed'}
    end

    # Handle the event
    case event.type
    when 'payment_intent.succeeded'
      payment_intent = event.data.object # contains a Stripe::PaymentIntent
      # Then define and call a method to handle the successful payment intent.
      # handle_payment_intent_succeeded(payment_intent)
      logger.debug "Payment succeeded"
      logger.debug "* - Session Total = #{payment_intent.amount_received}"
      logger.debug "* - Session status = #{payment_intent.charges.data[0].billing_details.email}"


    when 'payment_method.attached'
      payment_method = event.data.object # contains a Stripe::PaymentMethod

      # Then define and call a method to handle the successful attachment of a PaymentMethod.
      # handle_payment_method_attached(payment_method)
    # ... handle other event types
    when 'checkout.session.completed'
      payment_method = event.data.object # contains a Stripe::PaymentMethod
      session = event.data.object
      # logger.debug "Session completed"
      # logger.debug "Session Total = #{session.amount_total}"
      # logger.debug "Session status = #{session.payment_status}"
      # logger.debug "Session EMAIL CHECKOUT = #{session.customer_details.email}"
      # logger.debug "Session email = #{session.customer_email}"
      # logger.debug "Session Description = #{session.display_items[0].custom.description}"

    	if !session.metadata
        logger.debug "Session metadata = #{session.metadata}"
      else
        logger.debug "Session metadata = #{session.metadata.class}"
      end

      if session.metadata.keys.count == 0
        logger.debug "Session Empty = #{session.metadata}"
      end

      if !session.metadata.member?("property_id")
        logger.debug "Check Property ID --> = #{session.metadata}"
      end
      @reservation = Reservation.find(session.metadata.reservation_id)
      @reservation.set_paid
		  @reservation.save

      @owner = User.find(@reservation.owner_id)
      @tenant = User.find(@reservation.user_id)
      HostReservationBookedNotification.with(reservation: @reservation).deliver_later(@owner)
      TenantReservationBookedNotification.with(reservation: @reservation).deliver_later(@tenant)

      #logger.debug "Session status = #{session.billing_details.email}"
      # Then define and call a method to handle the successful attachment of a PaymentMethod.
      # handle_payment_method_attached(payment_method)
  # ... handle other event types
    else
      puts "Unhandled event type: #{event.type}"
    end

    render json: {message: 'success'}
  end
end
