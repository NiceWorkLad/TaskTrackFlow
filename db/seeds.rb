# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Create sample tasks
User.find_or_create_by!(email: "email@gmail.com") do |user|
  user.password = "securepassword"
end

puts "Seeded users successfully."

User.find_or_create_by!(email: "email2@gmail.com") do |user|
  user.password = "securepassword2"
end

puts "Seeded users successfully."

Task.find_or_create_by!(title: "Setup project") do |task|
  task.description = "Initialize Rails project and configure database"
  task.status = "pending"
  task.public = true
  task.due_date = Date.today + 77992.days
  task.user = User.first
end

Task.find_or_create_by!(title: "Write documentation") do |task|
  task.description = "Document API endpoints and usage"
  task.status = "pending"
  task.public = true
  task.due_date = Date.today + 0.days
  task.user = User.first
end

Task.find_or_create_by!(title: "Deploy to production") do |task|
  task.description = "Deploy application to production server"
  task.status = "in_progress"
  task.public = false
  task.due_date = Date.today + 28.days
  task.user = User.first
end

Task.find_or_create_by!(title: "Code review") do |task|
  task.description = "Review pull requests from team members"
  task.status = "in_progress"
  task.public = true
  task.due_date = Date.today + 2.days
  task.user = User.first
end

Task.find_or_create_by!(title: "Fix bugs") do |task|
  task.description = "Address reported issues in bug tracker"
  task.status = "completed"
  task.public = false
  task.due_date = Date.today + 6.days
  task.user = User.first
end

puts "Seeded tasks successfully."
