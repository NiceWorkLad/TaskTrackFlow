class AddVisibilityForTasks < ActiveRecord::Migration[8.0]
  def change
    add_column :tasks, :visibility, :integer, null: false, default: 0

    reversible do |dir|
      dir.up do
        execute <<~SQL
          UPDATE tasks
          SET visibility = CASE
            WHEN public = 1 THEN 0
            ELSE 1
          END
        SQL
      end
    end

    remove_column :tasks, :public, :boolean
  end
end
