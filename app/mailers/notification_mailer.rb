class NotificationMailer < ApplicationMailer

  default from: 'noreply@nomadroof.com'

  def comment_notification
    mail(to: params[:recipient].email, subject: "My subject")
  end

  def message_notification
    @conversation = Conversation.find(params[:message].conversation_id)
    @other = params[:recipient] == @conversation.sender ? @conversation.recipient : @conversation.sender
    mail(to: params[:recipient].email, subject: "You have a new message!")
  end

  def host_booked
    @reservation = params[:reservation]
    @owner = User.find(@reservation.owner_id)
    @tenant = User.find(@reservation.user_id)
    #@other = params[:recipient] == @conversation.sender ? @conversation.recipient : @conversation.sender
    mail(to: params[:recipient].email, subject: "You have a new reservation confirmed!")
  end

  def guest_booked
    @reservation = params[:reservation]
    @owner = User.find(@reservation.owner_id)
    @tenant = User.find(@reservation.user_id)
    #@other = params[:recipient] == @conversation.sender ? @conversation.recipient : @conversation.sender
    mail(to: params[:recipient].email, subject: "Your booking is confirmed!")
  end

end
