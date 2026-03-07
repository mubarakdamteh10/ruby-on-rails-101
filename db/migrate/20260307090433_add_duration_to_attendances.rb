class AddDurationToAttendances < ActiveRecord::Migration[8.1]
  def change
    add_column :attendances, :duration, :string
  end
end
