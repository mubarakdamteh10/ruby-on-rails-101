# HRMS

A comprehensive Ruby on Rails 8.1 application for managing employees, tracking attendance, and processing payroll.

## 🏁 Initial Setup Guide

Follow these steps to get the project running on your local machine for the first time.

### Prerequisites

Ensure you have the following installed:
- **Ruby 3.4.8** (Recommended: use `rbenv` or `rvm`)
- **PostgreSQL** (Active and running)
- **Bundler** (`gem install bundler`)

### Installation

1.  **Clone the repository**:
    ```bash
    git clone <repository-url>
    cd ruby-on-rails-101
    ```

2.  **Install dependencies**:
    ```bash
    bundle install
    ```

3.  **Setup for MacOS (Recommended)**:
    Start the database and prepare the environment with these commands:
    ```bash
    make db-start      # Start PostgreSQL via Docker
    make prepare-db    # Create, migrate, and seed the database
    ```

4.  **Start the development server**:
    ```bash
    bin/dev
    ```
    The application will be available at `http://localhost:3000`.

### Alternative (Manual) Setup
If you are not using the Makefile/Docker:
1.  **Setup the database**:
    ```bash
    bin/rails db:setup
    ```
2.  **Start the Rails server**:
    ```bash
    bin/rails server
    ```

## 🚀 MVP Features

The current Minimum Viable Product (MVP) includes the following core modules:

- **Authentication**: Simple session-based sign-in/sign-out mechanism.
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

## 🛠 Tech Stack

- **Framework**: [Ruby on Rails 8.1](https://rubyonrails.org/)
- **Language**: [Ruby 3.4.8](https://www.ruby-lang.org/)
- **Database**: [PostgreSQL](https://www.postgresql.org/)
- **Assets**: [Importmaps](https://github.com/rails/importmap-rails) (No Node.js required for JS management)
- **Deployment**: Ready for [Kamal](https://kamal-deploy.org/) and Docker.

## 📖 Using the Application

### Initial Data
The project comes with seeded data to help you explore the features immediately. Check `db/seeds.rb` for the list of initial employees.

### Accessing the App
- **Sign In**: Navigate to the root URL (`/`) to access the sign-in options.
- **Admin Dashboard**: Accessible via `/admin` (or defined routes).
- **Employee Access**: Employees can check in/out using their specific code via the attendance routes.

### Common Commands
- **Run Tests**: `bin/rails test`
- **Check Routes**: `bin/rails routes`
- **Interactive Console**: `bin/rails console`
* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
