class Message < ActiveRecord::Base
  belongs_to :conversation
  belongs_to :user

  validates_presence_of :content, :conversation_id, :user_id

  def message_time
  	created_at.strftime("%v")
  end

  after_create_commit :notify_user

  def notify_user
    #CommentNotification.with(message: self).deliver_later(User.all)
  end

end
