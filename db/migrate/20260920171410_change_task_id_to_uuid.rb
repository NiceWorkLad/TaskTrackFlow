class ChangeTaskIdToUuid < ActiveRecord::Migration[8.0]
  def up
    create_table :tasks_new, id: :string do |t|
      t.string :title
      t.text :description
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
      t.integer :user_id
      t.string :priority, default: "low"
      t.date :due_date
      t.string :status, default: "pending"
      t.text :body
      t.boolean :completed, default: false
      t.integer :visibility, default: 0, null: false

      t.index :user_id
    end

    old_tasks = select_all("SELECT * FROM tasks")

    old_tasks.each do |task|
      id = SecureRandom.uuid

      values = [
        id,
        task["title"],
        task["description"],
        task["created_at"],
        task["updated_at"],
        task["user_id"],
        task["priority"],
        task["due_date"],
        task["status"],
        task["body"],
        task["completed"],
        task["visibility"]
        ]

        quoted_values = values.map do |value|
          ActiveRecord::Base.connection.quote(value)
        end

      execute <<~SQL
        INSERT INTO tasks_new (
          id,
          title,
          description,
          created_at,
          updated_at,
          user_id,
          priority,
          due_date,
          status,
          body,
          completed,
          visibility
        )
        VALUES (#{quoted_values.join(", ")})
        SQL
    end

    drop_table :tasks
    rename_table :tasks_new, :tasks
  end

  def down
    raise ActiveRecord::IrreversibleMigration,
      "Cannot safely convert UUID task IDs back to the original integer IDs"
  end
end
