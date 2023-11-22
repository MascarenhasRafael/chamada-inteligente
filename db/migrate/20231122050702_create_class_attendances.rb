class CreateClassAttendances < ActiveRecord::Migration[7.0]
  def change
    create_table :class_attendances do |t|
      t.string :professor_id, null: false
      t.string :professor_latitude, null: false
      t.string :professor_longitude, null: false
      t.string :classroom_id, null: false
      t.string :status, default: :active, null: false
      t.datetime :scheduled_to

      t.timestamps
    end
  end
end
