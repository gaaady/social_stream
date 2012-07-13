class AddSortByToActivity < ActiveRecord::Migration
  def up
    add_column :activities, :sorted_by, :datetime

    Activity.record_timestamps = false
    Activity.reset_column_information

    Activity.all.each do |a|
      if a.direct_object.present? and a.direct_object.respond_to? :given_at and a.direct_object.given_at.present?
        a.sorted_by = a.direct_object.given_at.to_datetime
      else
        a.sorted_by = a.created_at
      end

      a.save!
    end

    Activity.record_timestamps = true
    Activity.reset_column_information
  end

  def down
    remove_column :activities, :sorted_by
  end
end
