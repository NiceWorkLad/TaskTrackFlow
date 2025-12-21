class AddToStatus < ActiveRecord::Migration[8.0]
  def change
    remove_column :tasks, :completed, :boolean
    add_column :tasks, :status, :string, default: "pending"
  end
end
