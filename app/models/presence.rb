class Presence < ApplicationRecord
  belongs_to :class_attendance

  validates :class_attendance, :student_id, :latitude, :longitude, presence: true
end
