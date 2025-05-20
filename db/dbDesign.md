# Database Design Overview

This document provides a summary of the schema, relationships, and key concepts in the current PostgreSQL database.
It is used in a microservice architecture, and each table is designed with clear ownership and purpose.

## Tables and Their Roles

### 1. `courses`

Stores core course information.

| Field         | Type    | Description            |
|---------------|---------|------------------------|
| course_id     | text    | Primary key            |
| course_name   | text    | Name of the course     |
| semester      | text    | Academic semester      |
| description   | text    | Optional description   |
| created_at    | timestamp | Creation timestamp  |
| updated_at    | timestamp | Update timestamp     |

### 2. `students`

Stores registered students.

| Field         | Type    | Description        |
|---------------|---------|--------------------|
| student_id    | text    | Primary key        |
| name, email, etc. |     | Additional fields expected |

### 3. `staff_members`

Contains instructors and staff involved in teaching.

| Field         | Type    | Description        |
|---------------|---------|--------------------|
| staff_id      | text    | Primary key        |
| name, email, etc. |     | Additional fields expected |

### 4. `course_students`

Many-to-many mapping between students and courses.

| Field       | Type |
|-------------|------|
| course_id   | FK → `courses` |
| student_id  | FK → `students` |

### 5. `course_staffs`

Many-to-many mapping between staff and courses.

| Field       | Type |
|-------------|------|
| course_id   | FK → `courses` |
| staff_id    | FK → `staff_members` |

### 6. `grades`

Stores grades given to students.

| Field        | Type      | Description                        |
|--------------|-----------|------------------------------------|
| grade_id     | text      | Unique ID for the grade (nullable) |
| course_id    | FK        | → `courses`                        |
| student_id   | FK        | → `students`                       |
| grade_type   | text      | e.g., "final", "midterm", etc.     |
| grade_value  | text      | Grade value                        |
| graded_by    | FK        | → `staff_members` (nullable)       |
| graded_at    | timestamp | When it was graded                 |
| comments     | text      | Optional remarks                   |

**Constraints**:

- Grades are linked to `course_students` to ensure validity.
- Graded staff must be associated with the same course (`course_staffs`).

### 7. `homework`

Stores assignments for a course.

| Field        | Type      |
|--------------|-----------|
| homework_id  | uuid      |
| course_id    | FK → `courses` |
| title, due_date, etc. | Additional fields expected |

### 8. `submissions`

Stores homework submissions by students.

| Field         | Type      |
|---------------|-----------|
| submission_id | uuid      |
| homework_id   | FK → `homework` |
| student_id    | FK → `students` |
| content, submitted_at, etc. | Additional fields |

### 9. `announcements`

Course-specific announcements.

| Field          | Type      |
|----------------|-----------|
| announcement_id | text     |
| course_id       | FK → `courses` |
| title, content, created_at, etc. | Fields to manage posts |

## Relationships Summary

- **Courses** have many **students**, **staff members**, **grades**, **homework**, and **announcements**.
- **Grades** reference both **students** and **staff**, and ensure consistency by checking course membership.
- **Homework** belongs to a course, and each **submission** must be linked to a **homework** and a **student**.
- **Announcements** are scoped to courses.

## Notes

- Foreign key (FK) constraints use `ON DELETE CASCADE` or `SET NULL` to maintain referential integrity.
- The database uses UUIDs (via the `uuid-ossp` extension) for some tables.
