class AddRoomRefToConversations < ActiveRecord::Migration[6.1]
  def change
    add_reference :conversations, :room, foreign_key: true
  end
end
