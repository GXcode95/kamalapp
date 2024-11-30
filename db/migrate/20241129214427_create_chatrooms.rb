class CreateChatrooms < ActiveRecord::Migration[8.0]
  def change
    create_table :chatrooms do |t|
      t.string :name

      t.timestamps
    end
  end
end
