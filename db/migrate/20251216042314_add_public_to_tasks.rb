class AddPublicToTasks < ActiveRecord::Migration[8.0]
  def change
    add_column :tasks, :public, :boolean, default: false
  end
end
