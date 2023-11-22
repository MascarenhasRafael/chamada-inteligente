class CreatePresences < ActiveRecord::Migration[7.0]
  def change
    create_table :presences do |t|
      t.string :student_id, null: false
      t.string :latitude, null: false
      t.string :longitude, null: false
      t.references :class_attendance, null: false, foreign_key: true
      t.datetime :approved_at
      t.datetime :declined_at

      t.timestamps
    end
  end
end
