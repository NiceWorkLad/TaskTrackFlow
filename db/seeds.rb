# db/seeds.rb

# Clear existing data
Comment.delete_all
Task.delete_all
User.delete_all

# =========================
# Users
# =========================

alice = User.create!(
  username: "alice",
  email: "alice@example.com",
  password: "password123",
  password_confirmation: "password123"
)

bob = User.create!(
  username: "bob",
  email: "bob@example.com",
  password: "password123",
  password_confirmation: "password123"
)

charlie = User.create!(
  username: "charlie",
  email: "charlie@example.com",
  password: "password123",
  password_confirmation: "password123"
)

# =========================
# Tasks
# =========================

# Public task
task_1 = Task.create!(
  title: "Build comments system",
  description: "Add comments and replies to tasks.",
  body: "Implement comments on the task show page.",
  user: alice,
  priority: "high",
  status: "in_progress",
  completed: false,
  visibility: 0
)

# Public task
task_2 = Task.create!(
  title: "Learn Rails testing",
  description: "Write tests for the application's main features.",
  body: "Add model, controller, and integration tests.",
  user: bob,
  priority: "medium",
  status: "pending",
  completed: false,
  visibility: 0
)

# Private task
task_3 = Task.create!(
  title: "Private project notes",
  description: "Development notes that should only be visible to the owner.",
  body: "These are private development notes.",
  user: alice,
  priority: "low",
  status: "pending",
  completed: false,
  visibility: 2
)

# Unlisted task
task_4 = Task.create!(
  title: "Share this task by link",
  description: "An unlisted task for testing link-only access.",
  body: "This task should not appear in public task listings.",
  user: charlie,
  priority: "medium",
  status: "completed",
  completed: true,
  visibility: 1
)

# =========================
# Comments - Task 1
# =========================

comment_1 = task_1.comments.create!(
  body: "This looks like a useful feature.",
  user: bob
)

comment_2 = task_1.comments.create!(
  body: "Agreed. I'm particularly interested in threaded replies.",
  user: charlie
)

comment_3 = task_1.comments.create!(
  body: "How are you planning to handle permissions?",
  user: alice
)

# =========================
# Replies - Comment 1
# =========================

comment_1.replies.create!(
  body: "Yeah, I think nested replies will be useful.",
  user: alice,
  task: task_1
)

comment_1.replies.create!(
  body: "The parent_id relationship seems pretty straightforward.",
  user: charlie,
  task: task_1
)

# =========================
# Replies - Comment 2
# =========================

comment_2.replies.create!(
  body: "I'm testing this one as a reply to another comment.",
  user: bob,
  task: task_1
)

comment_2.replies.create!(
  body: "Replies should probably only be shown under their parent.",
  user: alice,
  task: task_1
)

# =========================
# Reply to a reply
# =========================

comment_1.replies.first.replies.create!(
  body: "Exactly. That should make the UI much easier to understand.",
  user: bob,
  task: task_1
)

# =========================
# Comments - Task 2
# =========================

task_2.comments.create!(
  body: "Have you started writing the model tests?",
  user: alice
)

task_2.comments.create!(
  body: "Yep, the associations are working now.",
  user: bob
)

task_2.comments.create!(
  body: "Don't forget to test the authorization rules as well.",
  user: charlie
)

# =========================
# Comments - Task 3
# =========================

task_3.comments.create!(
  body: "This is a comment on a private task.",
  user: bob
)

# =========================
# Comments - Task 4
# =========================

task_4.comments.create!(
  body: "This task is being shared through an unlisted URL.",
  user: alice
)

task_4.comments.create!(
  body: "It shouldn't appear in the public task index.",
  user: charlie
)

# =========================
# Seed summary
# =========================

puts "Seeded #{User.count} users"
puts "Seeded #{Task.count} tasks"
puts "Seeded #{Comment.count} comments"
puts "  Public tasks: #{Task.where(visibility: 0).count}"
puts "  Unlisted tasks: #{Task.where(visibility: 1).count}"
puts "  Private tasks: #{Task.where(visibility: 2).count}"