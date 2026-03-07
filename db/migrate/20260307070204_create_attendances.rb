class CreateAttendances < ActiveRecord::Migration[8.1]
  def change
    create_table :attendances, primary_key: :attendance_id, id: :uuid, default: -> { "gen_random_uuid()" } do |t|
      t.references :employee, null: false, type: :uuid, foreign_key: { primary_key: :employee_id }
      t.datetime :check_in
      t.datetime :check_out
      t.integer :over_time_hour
      t.datetime :timestamp

      t.timestamps
    end
  end
end
