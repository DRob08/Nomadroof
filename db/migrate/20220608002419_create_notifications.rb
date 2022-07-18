class CreateNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :notifications do |t|
      t.references :recipient, polymorphic: true
      t.string :type, null: false
      t.json :params
      t.datetime :read_at

      t.timestamps
    end
    add_index :notifications, :read_at
  end
end
