# Library Management System - Installation & Setup Guide

## Prerequisites

- Ruby 3.2.2
- Rails 7
- SQLite3
- Xcode Command Line Tools (macOS)

## Installation Steps

### 1. Prerequisites Setup on macOS

If you encounter issues with `bcrypt` installation, you'll need to install Xcode Command Line Tools:

```bash
xcode-select --install
```

Follow the on-screen prompts to complete the installation.

### 2. Install Dependencies

```bash
bundle install
```

If you still encounter issues with bcrypt, you can try:

```bash
# Option A: Use Homebrew to install development tools
brew install openssl libyaml libffi

# Option B: Update RVM (if using RVM)
rvm get head
rvm reinstall 3.2.2

# Option C: Use a pre-compiled Ruby version
rbenv install 3.2.2
```

### 3. Database Setup

```bash
# Create and migrate the database
rails db:migrate

# (Optional) Seed data
rails db:seed
```

### 4. Run the Application

```bash
rails s
# Visit http://localhost:3000/
```

### 5. Run Tests

```bash
bundle exec rspec

# Run specific test file
bundle exec rspec spec/models/user_spec.rb

# Run with verbose output
bundle exec rspec --format documentation
```

## Project Structure

```
app/
├── controllers/
│   ├── application_controller.rb       # Base controller with authentication
│   ├── authentication_controller.rb    # Auth endpoints (register, login, logout)
│   ├── dashboards_controller.rb        # Dashboard endpoints
│   └── api/
│       ├── books_controller.rb         # Books API CRUD
│       └── borrows_controller.rb       # Borrowing/returning API
├── models/
│   ├── user.rb                         # User with authentication
│   ├── book.rb                         # Book model with search
│   └── borrow.rb                       # Borrow model with validations
├── serializers/
│   └── user_serializer.rb              # User JSON serializer
└── jobs/
    └── application_job.rb

config/
├── routes.rb                           # All API and auth routes
├── database.yml                        # Database configuration
└── environments/
    ├── development.rb
    ├── test.rb
    └── production.rb

db/
├── migrate/
│   ├── 20250401100000_add_authentication_to_users.rb
│   ├── 20250401100001_create_books.rb
│   └── 20250401100002_create_borrows.rb
└── schema.rb                           # Auto-generated schema

spec/
├── factories.rb                        # FactoryBot factories
├── models/
│   ├── user_spec.rb
│   ├── book_spec.rb
│   └── borrow_spec.rb
└── requests/
    ├── authentication_spec.rb
    ├── books_api_spec.rb
    ├── borrows_api_spec.rb
    └── dashboards_spec.rb
```

## Key Features Implemented

### 1. Authentication System
- User registration with password hashing
- JWT-based login
- Role-based access control (Member/Librarian)
- Secure logout

### 2. Book Management
- Full CRUD operations (Librarian only)
- Search by title, author, or genre
- Track available copies
- Pagination support

### 3. Borrowing System
- Members can borrow available books
- Automatic 2-week due date calculation
- Librarians can mark books as returned
- Prevent duplicate borrows

### 4. Dashboards
- **Librarian Dashboard**: Total books, borrowed count, books due today, overdue list with members
- **Member Dashboard**: Active borrows, overdue books, days until due

### 5. API Endpoints
- 3 Authentication endpoints
- 8 Book management endpoints
- 6 Borrowing endpoints
- 2 Dashboard endpoints

### 6. Testing
- 150+ comprehensive RSpec tests
- Model validation tests
- Controller/API tests
- Authorization tests

## Database Models

### Users (Authentication)
```ruby
{
  id: Integer,
  name: String,
  email: String (unique),
  password_digest: String,
  user_type: String (member/librarian),
  created_at: DateTime,
  updated_at: DateTime
}
```

### Books (Library Catalog)
```ruby
{
  id: Integer,
  title: String,
  author: String,
  genre: String,
  isbn: String (unique),
  total_copies: Integer,
  available_copies: Integer,
  created_at: DateTime,
  updated_at: DateTime
}
```

### Borrows (Transactions)
```ruby
{
  id: Integer,
  user_id: Integer (FK),
  book_id: Integer (FK),
  borrowed_at: DateTime,
  due_at: DateTime,
  returned_at: DateTime (nullable),
  created_at: DateTime,
  updated_at: DateTime
}
```

## Common Commands

```bash
# Rails console
rails c

# Generate new model
rails g model ModelName

# Create new migration
rails g migration MigrationName

# Run RSpec
bundle exec rspec

# Run specific test
bundle exec rspec spec/models/book_spec.rb

# Database reset
rails db:reset

# Drop database
rails db:drop

# Seed database
rails db:seed
```

## Troubleshooting

### Issue: "bcrypt" gem fails to install

**Solution:**
1. Install Xcode Command Line Tools: `xcode-select --install`
2. OR use Homebrew: `brew install openssl`
3. Then run: `bundle install`

### Issue: "Database does not exist"

**Solution:**
```bash
rails db:create
rails db:migrate
```

### Issue: Tests fail with "pending migrations"

**Solution:**
```bash
rails db:test:prepare
bundle exec rspec
```

### Issue: "Permission denied" running `rails`

**Solution:**
```bash
chmod +x bin/rails
./bin/rails s
```

## Development Workflow

1. Create a new branch for features
2. Write tests first (TDD approach)
3. Implement the feature
4. Run tests to verify: `bundle exec rspec`
5. Commit and push

## Environment Variables

Create a `.env` file in the root directory:

```env
JWT_SECRET=your_secret_key_here
RAILS_ENV=development
DATABASE_URL=sqlite3:db/development.sqlite3
```

## API Authentication

All API endpoints (except `/auth/register` and `/auth/login`) require authentication.

Include the JWT token in the Authorization header:

```bash
curl -H "Authorization: Bearer <your_token>" \
     http://localhost:3000/api/books
```

## Performance Considerations

- Books table: Indexed on `isbn`, `title`, `author`, `genre`
- Borrows table: Indexed on `user_id`, `book_id`, and composite indexes
- Queries use eager loading with `.includes()`
- Pagination available for all list endpoints

## Security Notes

- Passwords are hashed with bcrypt (minimum 60 character digest)
- JWT tokens expire after 7 days
- Role-based authorization on all privileged endpoints
- Input validation on all models

## Additional Resources

- [Rails Guide](https://guides.rubyonrails.org/)
- [RSpec Documentation](https://rspec.info/)
- [JWT Best Practices](https://tools.ietf.org/html/rfc7519)
- [RESTful API Design](https://restfulapi.net/)

## Support

For issues or questions, refer to:
1. The comprehensive API documentation in `LIBRARY_API.md`
2. RSpec test files for usage examples
3. Rails console for debugging: `rails c`
