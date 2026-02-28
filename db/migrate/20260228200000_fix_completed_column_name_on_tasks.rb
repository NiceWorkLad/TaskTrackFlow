class FixCompletedColumnNameOnTasks < ActiveRecord::Migration[8.0]
  def up
    return unless column_exists?(:tasks, "Completed")
    return if column_exists?(:tasks, :completed)

    rename_column :tasks, "Completed", :completed
  end

  def down
    return unless column_exists?(:tasks, :completed)
    return if column_exists?(:tasks, "Completed")

    rename_column :tasks, :completed, "Completed"
  end
end
