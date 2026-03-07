# 🏢 HRMS

A comprehensive Ruby on Rails 8.1 application for managing employees, tracking attendance, and processing payroll.

## 🏁 Initial Setup Guide

Follow these steps to get the project running on your local machine for the first time.

### Prerequisites

Ensure you have the following installed:
- **Ruby 3.4.8** (Recommended: use `rbenv` or `rvm`)
- **PostgreSQL** (Active and running)
- **Bundler** (`gem install bundler`)

### 🔑 Database Environment Variables

The application uses the following environment variables for database connection. You can set these in your shell or use a `.env` file:

| Variable | Description | Default Value |
| :--- | :--- | :--- |
| `DB_HOST` | Database host address | `127.0.0.1` |
| `DB_PORT` | Database port | `5432` |
| `DB_USER` | Database username | `maibok` |
| `DB_PASSWORD` | Database password | `password` |

### Installation

1.  **Clone the repository**:
    ```bash
    git clone git@github.com:mubarakdamteh10/ruby-on-rails-101.git
    cd ruby-on-rails-101
    ```

2.  **Install dependencies**:
    ```bash
    bundle install
    ```

3.  **Setup for MacOS (Recommended)**:
    Start the database and prepare the environment with these commands:
    ```bash
    make db-start
    make db-prepare
    ```

4.  **Start the development server**:
    ```bash
    bin/dev
    ```
    The application will be available at `http://localhost:3000`.

### Alternative (Manual) Setup
If you are not using the Makefile/Docker:
make sure you have PostgreSQL running
1.  **Setup the database**:
    ```bash
    bin/rails db:setup
    ```
2.  **Start the Rails server**:
    ```bash
    ```bash
    bin/rails server
    ```

## 🧪 Testing

The project includes unit, functional, and integration (system) tests.

### Running Tests
- **All Tests**: `make test`
- **System Tests (Visible)**: `make test-system`
- **System Tests (Headless)**: `bin/rails test:system`

### Debugging System Tests
You can run system tests in a "slow-motion" mode to see the browser interactions clearly:
```bash
DRIVER=chrome SLOW=true bin/rails test:system
```

## 🚀 MVP Features

The current Minimum Viable Product (MVP) includes the following core modules:

- **Authentication**: Simple session-based sign-in/sign-out mechanism. switch user role
- **Employee Management**:
    - Full CRUD (Create, Read, Update, Delete) for employee records.
    - Unique employee codes for easy identification.
- **Attendance Tracking**:
    - Daily check-in and check-out functionality.
    - Record duration Working time
    - Calculate Overtime
    - Automatic duration calculation for shifts.
- **Payroll Processing**:
    - Monthly payroll generation for employees.
    - Automated calculation of gross salary, OT payments, tax deductions, and net amount.
    - Idempotent payroll processing (prevents duplicate entries for the same month/year).

## ✨ Additional Features (Out of Scope)
    - Access control for different user roles (e.g., admin, employee).
        - Avoid tax on special employee
    - Theme dark/light mode.
    - payroll page

## 🤖 Agent
    - Antigravity
    - Gemini

## 🤝 Agent Cooperation and Contribution
    - project set up

    - database setup
        - schema
        - migrations
        - seed data
        
    - MVC implementation
        - authentication
        - employee management
        - attendance tracking
        - payroll processing

    - ✨ Additional Features (Out of Scope)
        - Access control for different user roles (e.g., admin, employee).
        - payroll calculator for all employees metrix
        - Theme dark/light mode.

    - unit testing


## 📜 Agent Instructions
    - Provides the best practices for ruby on rails development.

## 🎨 UX & Permissions
- **Landing Page**: Role-selection portal with visual identity cards for Admins and Employees.
- **Adaptive UI**: Navigation menus and features dynamically adjust based on user role.
- **Accessibility**: Native dark/light mode persistence and 100% mobile responsiveness.

| Feature | Admin | Employee |
|:---|:---:|:---:|
| **Employees** | Manage | No Access |
| **Attendance** | View All | Own Only |
| **Payroll** | Calculate | View Status |
| **Salary Estimator** | Access | Access |
| **Theme** | Toggle | Toggle |