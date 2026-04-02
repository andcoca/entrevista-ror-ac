# Library Management App (Ruby on Rails)

This repository contains a full-featured library management system built with Ruby on Rails. It includes:

- Manual authentication (no Devise/bcrypt dependency)
- Role-based access (member and librarian)
- Book catalog CRUD
- Borrow and return functionality
- API endpoints for books and borrows
- Bootstrap UI for web views
- RSpec tests with FactoryBot and Shoulda Matchers

## Requirements

- Ruby 3.2.2
- Rails 7.0.8
- SQLite3
- Node.js and Yarn (for assets pipeline)

## Installation

1. Clone the repository (if not already cloned):

```bash
git clone <repository-url>
cd entrevista-ror-ac
```

2. Install gems:

```bash
bundle install
```

3. Install JavaScript dependencies:

```bash
yarn install
```

4. Create and migrate the database:

```bash
rails db:create db:migrate
```

5. Seed initial data:

```bash
rails db:seed
```

## Running the app

Start the Rails server:

```bash
bundle exec rails server
```

Open in browser:

```text
http://localhost:3000
```

Default seeded users:

- Librarian: `librarian@example.com` / `password123`
- Member: `member@example.com` / `password123`

## RSpec test suite

Run all tests:

```bash
bundle exec rspec
```

Run specific tests:

```bash
bundle exec rspec spec/models/book_spec.rb
bundle exec rspec spec/requests/books_api_spec.rb
```

## Basic usage

- Sign in at `/sign_in`
- Sign up at `/sign_up`
- Dashboard: `/dashboard` (role-specific)
- Books CRUD: `/books`
- Borrow book from book show page

## API endpoints

- `GET /api/books`
- `GET /api/books/:id`
- `POST /api/books` (librarian only)
- `PATCH /api/books/:id` (librarian only)
- `DELETE /api/books/:id` (librarian only)
- `GET /api/books/search?q=...&type=title|author|genre`
- `GET /api/books/available`

- `GET /api/borrows`
- `GET /api/borrows/:id`
- `POST /api/borrows`
- `GET /api/borrows/overdue`
- `GET /api/borrows/due_today`
- `PATCH /api/borrows/:id/return` (librarian only)

## Notes

- Authentication is handled by `SessionsController` and `RegistrationsController` with SHA256+salt.
- API auth uses `/auth/login`, `/auth/logout` endpoints.
- No `devise` dependency is required (all Devise references have been removed).

## Troubleshooting

If you see errors about missing gems:

```bash
bundle install
```

If you have migration issues:

```bash
rails db:reset
```

## Development

Use the following commands during development:

- `rails console`
- `rails db:migrate:status`
- `rails routes`


