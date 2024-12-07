class AddLastVisitAtToChatroomsUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :chatrooms_users, :last_visit_at, :datetime

    reversible do |dir|
      dir.up do
        ChatroomsUser.update_all(last_visit_at: Time.zone.now)
      end
    end
  end
end
