class ChangeTaskIdInCommentsToUuid < ActiveRecord::Migration[8.0]
  def change
    change_column :comments, :task_id, :string
  end
end
