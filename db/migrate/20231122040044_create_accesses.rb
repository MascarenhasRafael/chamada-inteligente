class CreateAccesses < ActiveRecord::Migration[7.0]
  def change
    create_table :accesses do |t|
      t.string :user_email
      t.string :user_token
      t.string :auth_type
      t.datetime :expires_at

      t.timestamps
    end
  end
end
