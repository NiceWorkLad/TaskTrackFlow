class AddBodyToTasks < ActiveRecord::Migration[8.0]
  def change
    add_column :tasks, :body, :text
  end
end
