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
Task.find_or_create_by!(title: "Setup project") do |task|
  task.description = "Initialize Rails project and configure database"
  task.completed = true
end

Task.find_or_create_by!(title: "Write documentation") do |task|
  task.description = "Document API endpoints and usage"
  task.completed = false
end

Task.find_or_create_by!(title: "Deploy to production") do |task|
  task.description = "Deploy application to production server"
  task.completed = false
end

Task.find_or_create_by!(title: "Code review") do |task|
  task.description = "Review pull requests from team members"
  task.completed = false
end

Task.find_or_create_by!(title: "Fix bugs") do |task|
  task.description = "Address reported issues in bug tracker"
  task.completed = false
end

puts "Seeded tasks successfully."

User.find_or_create_by!(email: "email@gmail.com") do |user|
  user.password = "securepassword"
end

puts "Seeded users successfully."
