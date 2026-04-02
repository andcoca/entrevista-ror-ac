# 🚀 Task Management API – Generation Prompt

You are a senior software engineer.

Your task is to design and implement a RESTful API for a Task Management System following best engineering practices.

---

## 🎯 Requirements

Build a backend system that supports:

- CRUD operations for Tasks
- Each Task has:
  - id
  - title
  - description
  - status (e.g., pending, in_progress, completed)
  - due_date
  - user_id (relation to User)

Assume a basic User model already exists.

---

## 📡 API Specifications (MANDATORY)

Design the API following REST standards.

### 1. Create Task
- POST /tasks

Request body example:
{
  "title": "string",
  "description": "string",
  "status": "pending | in_progress | completed",
  "due_date": "ISO8601 date",
  "user_id": "number"
}

Response:
- 201 Created
- Returns created task

---

### 2. Get All Tasks
- GET /tasks

Optional query params:
- status
- user_id

Response:
- 200 OK
- List of tasks

---

### 3. Get Task by ID
- GET /tasks/:id

Response:
- 200 OK → Task object
- 404 Not Found

---

### 4. Update Task
- PUT /tasks/:id

Request body example (partial or full):
{
  "title": "string",
  "description": "string",
  "status": "pending | in_progress | completed",
  "due_date": "ISO8601 date"
}

Response:
- 200 OK
- Updated task
- 404 Not Found

---

### 5. Delete Task
- DELETE /tasks/:id

Response:
- 204 No Content
- 404 Not Found

---

## 🧼 Code Quality

- Follow SOLID principles
- Use meaningful naming
- Keep functions small and focused
- Avoid duplication (DRY)
- Include clear folder structure
- Add comments only where necessary

---

## ⚙️ Functionality Requirements

- Fully working CRUD API

Validation:
- Required fields must be enforced
- Status must be one of the allowed values
- due_date must be a valid ISO 8601 date

Error Handling:
- Use proper HTTP status codes
- Provide consistent error response format
- No runtime errors

---

## 🧾 Deliverables

Provide:

1. Folder structure
2. Full implementation
3. How to run the project
4. Example API requests (curl or Postman)