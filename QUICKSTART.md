# Quick Start Guide - Library Management System

## 5-Minute Setup

### 1. Install Required Tools
```bash
# On macOS, install Xcode CLI tools if needed
xcode-select --install
```

### 2. Install Dependencies
```bash
cd /Users/afcocac/Desktop/APPS/entrevista-ror-ac
bundle install
```

### 3. Setup Database
```bash
rails db:migrate
```

### 4. Start the Server
```bash
rails server
# Visit http://localhost:3000/
```

## Testing the API

### Using cURL or Postman

#### 1. Register a New Librarian
```bash
curl -X POST http://localhost:3000/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "user": {
      "name": "Admin Librarian",
      "email": "librarian@library.com",
      "password": "securepass123",
      "password_confirmation": "securepass123"
    }
  }'
```

Then manually update the user to librarian (in Rails console):
```bash
rails console
User.last.update(user_type: :librarian)
exit
```

#### 2. Register a Member
```bash
curl -X POST http://localhost:3000/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "user": {
      "name": "John Doe",
      "email": "john@example.com",
      "password": "password123",
      "password_confirmation": "password123"
    }
  }'
```

#### 3. Login
```bash
curl -X POST http://localhost:3000/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "user": {
      "email": "librarian@library.com",
      "password": "securepass123"
    }
  }'
```

Response will include: `"token": "eyJhbGc..."`

#### 4. Create a Book (Use Librarian Token)
```bash
curl -X POST http://localhost:3000/api/books \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <LIBRARIAN_TOKEN>" \
  -d '{
    "book": {
      "title": "The Hobbit",
      "author": "J.R.R. Tolkien",
      "genre": "Fantasy",
      "isbn": "978-0-7432-7356-5",
      "total_copies": 5
    }
  }'
```

#### 5. Search for Books
```bash
curl -X GET "http://localhost:3000/api/books/search?q=hobbit&type=title" \
  -H "Authorization: Bearer <MEMBER_TOKEN>"
```

#### 6. Borrow a Book (Use Member Token)
```bash
curl -X POST http://localhost:3000/api/borrows \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <MEMBER_TOKEN>" \
  -d '{"book_id": 1}'
```

#### 7. View Member Dashboard
```bash
curl -X GET http://localhost:3000/dashboards/member \
  -H "Authorization: Bearer <MEMBER_TOKEN>"
```

#### 8. View Librarian Dashboard
```bash
curl -X GET http://localhost:3000/dashboards/librarian \
  -H "Authorization: Bearer <LIBRARIAN_TOKEN>"
```

## Run Tests

```bash
# All tests
bundle exec rspec

# Only model tests
bundle exec rspec spec/models/

# Only API tests
bundle exec rspec spec/requests/

# Specific test file
bundle exec rspec spec/models/book_spec.rb

# With verbose output
bundle exec rspec --format documentation
```

## Documentation

Read the comprehensive docs:

1. **[LIBRARY_API.md](./LIBRARY_API.md)** - Complete API documentation with all endpoints and examples
2. **[SETUP_GUIDE.md](./SETUP_GUIDE.md)** - Detailed setup, troubleshooting, and project structure
3. **[IMPLEMENTATION_SUMMARY.md](./IMPLEMENTATION_SUMMARY.md)** - What was implemented and file listing

## Key Features Quick Reference

| Feature | Endpoint | Role |
|---------|----------|------|
| Register | `POST /auth/register` | Public |
| Login | `POST /auth/login` | Public |
| Create Book | `POST /api/books` | Librarian |
| Search Books | `GET /api/books/search` | All |
| Borrow Book | `POST /api/borrows` | Member |
| Return Book | `PATCH /api/borrows/:id/return` | Librarian |
| Member Dashboard | `GET /dashboards/member` | Member |
| Librarian Dashboard | `GET /dashboards/librarian` | Librarian |

## Important Notes

- **Default User Type**: New registrations default to "member"
- **Borrow Period**: 2 weeks from borrowing date
- **Duplicate Borrows**: Members cannot borrow the same book twice (must return first)
- **Token Expiration**: JWT tokens expire after 7 days
- **Authorization**: Most API endpoints require authentication header

## Common Issues & Solutions

### Issue: Database errors when running tests
```bash
rails db:test:prepare
bundle exec rspec
```

### Issue: bcrypt installation fails
Install Xcode CLI tools:
```bash
xcode-select --install
```

### Issue: Need to reset database
```bash
rails db:drop db:create db:migrate
```

### Issue: Can't find migrations
Make sure you're in the project root:
```bash
cd /Users/afcocac/Desktop/APPS/entrevista-ror-ac
```

## Using Rails Console for Testing

```bash
rails console

# Create a book
Book.create!(
  title: "1984",
  author: "George Orwell",
  genre: "Dystopian",
  isbn: "978-0-7432-7356-6",
  total_copies: 3
)

# Find a user
user = User.find_by(email: "john@example.com")

# Borrow a book
book = Book.first
borrow = book.borrow_by_user(user)

# View overdue books
Borrow.overdue

# Exit console
exit
```

## Project Statistics

- **API Endpoints**: 19 total
- **Models**: 3 new (User, Book, Borrow)
- **Controllers**: 4 (Authentication, Books API, Borrows API, Dashboards)
- **Tests**: 150+ RSpec test cases
- **Database Tables**: 4 (Users, Books, Borrows, Profiles)

## What's Implemented ✓

- ✓ User authentication with JWT
- ✓ Role-based access (Librarian/Member)
- ✓ Complete book management system
- ✓ Borrowing and returning workflow
- ✓ Overdue tracking
- ✓ Search functionality
- ✓ Two dashboards (Librarian & Member)
- ✓ Comprehensive RSpec test suite
- ✓ Complete API documentation
- ✓ Proper error handling and status codes

## Next Steps After Setup

1. Create some test books as a librarian
2. Borrow books as a member
3. Check the dashboards
4. Run the full test suite to verify everything works
5. Read LIBRARY_API.md for detailed endpoint documentation

---

**For full details, see the documentation files in the project root.**
