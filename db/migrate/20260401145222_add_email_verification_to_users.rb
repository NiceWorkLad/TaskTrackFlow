class AddEmailVerificationToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :pin, :integer
    add_column :users, :pin_sent_at, :datetime
    add_column :users, :email_verified, :boolean, default: false
  end
end
