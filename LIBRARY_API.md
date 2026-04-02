# Library Management System API Documentation

## Overview

This is a comprehensive library management system built with Ruby on Rails that includes authentication, book management, borrowing functionality, and role-based dashboards.

## Setup Instructions

```bash
# Install dependencies
bundle install

# Run migrations
rails db:migrate

# Run seeds (optional)
rails db:seed

# Run the server
rails s

# Visit http://localhost:3000/
```

## Run Tests

```bash
# Run all tests
bundle exec rspec

# Run specific test file
bundle exec rspec spec/models/book_spec.rb

# Run with coverage
bundle exec rspec --format progress
```

## Features

### 1. Authentication & Authorization

#### User Types
- **Librarian**: Can manage books (create, edit, delete), mark books as returned, view librarian dashboard
- **Member**: Can borrow/return books, view member dashboard

#### Authentication Endpoints

##### Register a New User
```
POST /auth/register
Content-Type: application/json

{
  "user": {
    "name": "John Doe",
    "email": "john@example.com",
    "password": "password123",
    "password_confirmation": "password123"
  }
}
```
**Response:** `status: 201`
```json
{
  "message": "User registered successfully",
  "user": {
    "id": 1,
    "name": "John Doe",
    "email": "john@example.com",
    "user_type": "member",
    "created_at": "2025-04-01T10:00:00Z",
    "updated_at": "2025-04-01T10:00:00Z"
  }
}
```

##### Login
```
POST /auth/login
Content-Type: application/json

{
  "user": {
    "email": "john@example.com",
    "password": "password123"
  }
}
```
**Response:** `status: 200`
```json
{
  "message": "Login successful",
  "token": "eyJhbGciOiJIUzI1NiJ9...",
  "user": {
    "id": 1,
    "name": "John Doe",
    "email": "john@example.com",
    "user_type": "member"
  }
}
```

##### Logout
```
POST /auth/logout
Authorization: Bearer <token>
```
**Response:** `status: 200`
```json
{
  "message": "Logged out successfully"
}
```

### 2. Book Management

All book management endpoints require authentication. Only librarians can create, update, or delete books.

#### List All Books
```
GET /api/books
Authorization: Bearer <token>
```
**Response:** `status: 200`
```json
[
  {
    "id": 1,
    "title": "The Hobbit",
    "author": "J.R.R. Tolkien",
    "genre": "Fantasy",
    "isbn": "978-0551010000",
    "total_copies": 5,
    "available_copies": 3,
    "created_at": "2025-04-01T10:00:00Z",
    "updated_at": "2025-04-01T10:00:00Z"
  }
]
```

#### Get a Specific Book
```
GET /api/books/{id}
Authorization: Bearer <token>
```
**Response:** `status: 200`
```json
{
  "id": 1,
  "title": "The Hobbit",
  "author": "J.R.R. Tolkien",
  "genre": "Fantasy",
  "isbn": "978-0551010000",
  "total_copies": 5,
  "available_copies": 3,
  "created_at": "2025-04-01T10:00:00Z",
  "updated_at": "2025-04-01T10:00:00Z"
}
```

#### Create a Book (Librarian Only)
```
POST /api/books
Authorization: Bearer <librarian_token>
Content-Type: application/json

{
  "book": {
    "title": "The Hobbit",
    "author": "J.R.R. Tolkien",
    "genre": "Fantasy",
    "isbn": "978-0551010000",
    "total_copies": 5
  }
}
```
**Response:** `status: 201`
```json
{
  "id": 1,
  "title": "The Hobbit",
  "author": "J.R.R. Tolkien",
  "genre": "Fantasy",
  "isbn": "978-0551010000",
  "total_copies": 5,
  "available_copies": 5
}
```

#### Update a Book (Librarian Only)
```
PATCH /api/books/{id}
Authorization: Bearer <librarian_token>
Content-Type: application/json

{
  "book": {
    "title": "Updated Title",
    "total_copies": 10
  }
}
```
**Response:** `status: 200`

#### Delete a Book (Librarian Only)
```
DELETE /api/books/{id}
Authorization: Bearer <librarian_token>
```
**Response:** `status: 200`
```json
{
  "message": "Book deleted successfully"
}
```

#### Search Books
```
GET /api/books/search?q=query&type=title
Authorization: Bearer <token>
```
Query Parameters:
- `q`: Search query
- `type`: Search type - `title`, `author`, or `genre` (default: `title`)

**Response:** `status: 200`
```json
[
  {
    "id": 1,
    "title": "The Hobbit",
    "author": "J.R.R. Tolkien",
    "genre": "Fantasy",
    "isbn": "978-0551010000",
    "total_copies": 5,
    "available_copies": 3
  }
]
```

#### Get Available Books
```
GET /api/books/available
Authorization: Bearer <token>
```
**Response:** `status: 200`
```json
[
  {
    "id": 1,
    "title": "The Hobbit",
    "author": "J.R.R. Tolkien",
    "genre": "Fantasy",
    "isbn": "978-0551010000",
    "total_copies": 5,
    "available_copies": 3
  }
]
```

### 3. Borrowing & Returning Books

#### Borrow a Book
```
POST /api/borrows
Authorization: Bearer <member_token>
Content-Type: application/json

{
  "book_id": 1
}
```
**Response:** `status: 201`
```json
{
  "id": 1,
  "user_id": 1,
  "book_id": 1,
  "borrowed_at": "2025-04-01T10:00:00Z",
  "due_at": "2025-04-15T10:00:00Z",
  "returned_at": null
}
```
**Possible Errors:**
- `422`: Book not available
- `422`: User already borrowed this book
- `404`: Book not found

#### List Borrows
```
GET /api/borrows
Authorization: Bearer <token>
```
- Members see only their borrows
- Librarians see all borrows

**Response:** `status: 200`
```json
[
  {
    "id": 1,
    "user_id": 1,
    "book_id": 1,
    "borrowed_at": "2025-04-01T10:00:00Z",
    "due_at": "2025-04-15T10:00:00Z",
    "returned_at": null,
    "user": {
      "id": 1,
      "name": "John Doe",
      "email": "john@example.com",
      "user_type": "member"
    },
    "book": {
      "id": 1,
      "title": "The Hobbit",
      "author": "J.R.R. Tolkien",
      "genre": "Fantasy"
    }
  }
]
```

#### Get Specific Borrow
```
GET /api/borrows/{id}
Authorization: Bearer <token>
```
**Response:** `status: 200`

#### Return a Book (Librarian Only)
```
PATCH /api/borrows/{id}/return
Authorization: Bearer <librarian_token>
```
**Response:** `status: 200`
```json
{
  "id": 1,
  "user_id": 1,
  "book_id": 1,
  "borrowed_at": "2025-04-01T10:00:00Z",
  "due_at": "2025-04-15T10:00:00Z",
  "returned_at": "2025-04-08T14:30:00Z"
}
```

#### Get Overdue Books
```
GET /api/borrows/overdue
Authorization: Bearer <librarian_token>
```
**Response:** `status: 200`
```json
[
  {
    "id": 1,
    "user_id": 1,
    "book_id": 1,
    "borrowed_at": "2025-04-01T10:00:00Z",
    "due_at": "2025-03-31T10:00:00Z",
    "returned_at": null,
    "user": {
      "id": 1,
      "name": "John Doe",
      "email": "john@example.com",
      "user_type": "member"
    },
    "book": {
      "id": 1,
      "title": "The Hobbit",
      "author": "J.R.R. Tolkien"
    }
  }
]
```

#### Get Books Due Today
```
GET /api/borrows/due-today
Authorization: Bearer <librarian_token>
```
**Response:** `status: 200`

### 4. Dashboards

#### Librarian Dashboard
```
GET /dashboards/librarian
Authorization: Bearer <librarian_token>
```
**Response:** `status: 200`
```json
{
  "total_books": 25,
  "total_borrowed_books": 8,
  "books_due_today": 2,
  "overdue_count": 3,
  "members_with_overdue": [
    {
      "id": 1,
      "name": "John Doe",
      "email": "john@example.com",
      "overdue_books": [
        {
          "book_id": 1,
          "title": "The Hobbit",
          "days_overdue": 5
        }
      ]
    }
  ]
}
```

#### Member Dashboard
```
GET /dashboards/member
Authorization: Bearer <member_token>
```
**Response:** `status: 200`
```json
{
  "borrowed_books": [
    {
      "id": 1,
      "book_id": 1,
      "title": "The Hobbit",
      "author": "J.R.R. Tolkien",
      "borrowed_at": "2025-04-01T10:00:00Z",
      "due_at": "2025-04-15T10:00:00Z",
      "days_until_due": 14,
      "is_overdue": false
    }
  ],
  "overdue_books": [],
  "total_borrowed": 1,
  "total_overdue": 0
}
```

## Database Schema

### Users
- `id`: Primary Key
- `name`: String
- `email`: String (unique)
- `password_digest`: String (encrypted)
- `user_type`: String (member/librarian)
- `created_at`, `updated_at`: Timestamps

### Books
- `id`: Primary Key
- `title`: String
- `author`: String
- `genre`: String
- `isbn`: String (unique)
- `total_copies`: Integer
- `available_copies`: Integer
- `created_at`, `updated_at`: Timestamps

### Borrows
- `id`: Primary Key
- `user_id`: Foreign Key (Users)
- `book_id`: Foreign Key (Books)
- `borrowed_at`: DateTime
- `due_at`: DateTime
- `returned_at`: DateTime (nullable)
- `created_at`, `updated_at`: Timestamps

## Error Responses

### 401 Unauthorized
```json
{
  "error": "Invalid token"
}
```
or
```json
{
  "error": "Missing authorization header"
}
```

### 403 Forbidden
```json
{
  "error": "Only librarians can perform this action"
}
```

### 404 Not Found
```json
{
  "error": "Book not found"
}
```

### 422 Unprocessable Entity
```json
{
  "errors": ["Title can't be blank", "Author can't be blank"]
}
```

## Testing

The application includes comprehensive RSpec tests covering:

- Model validations and associations
- Model scopes and methods
- Authentication endpoints
- Book API CRUD operations
- Book search functionality
- Borrow/return functionality
- Dashboard functionality
- Authorization checks

Run tests with:
```bash
bundle exec rspec
```

## Authentication

The API uses JWT (JSON Web Tokens) for authentication. Include the token in the `Authorization` header:

```
Authorization: Bearer <your_jwt_token>
```

JWT tokens expire after 7 days.

## Notes

- By default, new users are registered as `member` type
- Members can't borrow the same book twice (must return before borrowing again)
- Borrowing period is 2 weeks from the borrowing date
- Books can be returned by librarians only
- Search is case-insensitive
