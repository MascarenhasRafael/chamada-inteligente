class Access < ApplicationRecord
  validates :user_email, :user_token, :auth_type, :expires_at, presence: true
end
