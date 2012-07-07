class AddNotifiedAfterDraftToActivityObject < ActiveRecord::Migration
  def up
    add_column :activity_objects, :notified_after_draft, :boolean, :default => false
  end

  def down
    remove_column :activity_object, :notified_after_draft
  end
end
