class CreateConversations < ActiveRecord::Migration[6.1]
  def change
    create_table :conversations do |t|
      t.integer :sender_id
      t.integer :recipient_id

      t.timestamps null: false
    end
  end
end
