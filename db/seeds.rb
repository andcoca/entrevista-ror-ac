# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
# Event.create(title: "Birthday Party", date: Date.today + 6.months)

# Create librarians and members using ActiveRecord so authentication callbacks run correctly
librarian = User.find_or_initialize_by(email: 'admin@library.com')
librarian.name = 'Admin Librarian'
librarian.password = 'password123'
librarian.password_confirmation = 'password123'
librarian.user_type = 'librarian'
librarian.save!

member = User.find_or_initialize_by(email: 'member@library.com')
member.name = 'Library Member'
member.password = 'password123'
member.password_confirmation = 'password123'
member.user_type = 'member'
member.save!

# Optional sample books
Book.find_or_create_by!(isbn: '9780140449136') do |b|
  b.title = 'The Odyssey'
  b.author = 'Homer'
  b.genre = 'Classics'
  b.total_copies = 5
  b.available_copies = 5
end

Book.find_or_create_by!(isbn: '9780143127550') do |b|
  b.title = 'Sapiens: A Brief History of Humankind'
  b.author = 'Yuval Noah Harari'
  b.genre = 'Nonfiction'
  b.total_copies = 3
  b.available_copies = 3
end

puts "✅ Seeder completed: librarian, member, books created."
