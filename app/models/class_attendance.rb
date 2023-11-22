class ClassAttendance < ApplicationRecord
  validates :professor_id, :classroom_id, :status, :professor_latitude, :professor_longitude, presence: true
end
