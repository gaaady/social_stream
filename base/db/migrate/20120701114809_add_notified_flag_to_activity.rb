class AddNotifiedFlagToActivity < ActiveRecord::Migration
  def up
    add_column :activities, :notified, :boolean, :default => false
  end

  def down
    remove_column :activities, :notified
  end
end
