# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
employees = [
  {
    code: "EMP-001",
    name: "Alice Johnson",
    department: "Engineering",
    position: "Backend Developer",
    email: "alice.johnson@example.com",
    phone: "+1-555-0101",
    address: "123 Main St, New York, NY"
  },
  {
    code: "EMP-002",
    name: "Brian Lee",
    department: "Product",
    position: "Product Manager",
    email: "brian.lee@example.com",
    phone: "+1-555-0102",
    address: "456 Pine Ave, San Francisco, CA"
  },
  {
    code: "EMP-003",
    name: "Carla Gomez",
    department: "Design",
    position: "UI Designer",
    email: "carla.gomez@example.com",
    phone: "+1-555-0103",
    address: "789 Oak Blvd, Austin, TX"
  },
  {
    code: "EMP-004",
    name: "Anaconde Sung",
    department: "Human Resources",
    position: "HR Specialist",
    email: "anaconde@example.com",
    phone: "+1-555-0104",
    address: "777 Bang sue, Bangkok, BKK"
  },
  {
    code: "EMP-005",
    name: "Sung Jin woo",
    department: "Operations",
    position: "Operations Lead",
    email: "im_the_best@example.com",
    phone: "+1-555-0107",
    address: "999 Myeongdong, Seoul, KR"
  }
]

employees.each do |employee_attributes|
  Employee.find_or_create_by!(code: employee_attributes[:code]) do |employee|
    employee.assign_attributes(employee_attributes)
  end
end
