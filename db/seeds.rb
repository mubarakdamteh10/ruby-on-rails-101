# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

employees = [
  {
    code: "EMP-001",
    name: "Alice Johnson",
    department: "Engineering",
    position: "Backend Developer",
    email: "alice.johnson@yourmom.com",
    phone: "+1-555-0101",
    address: "123 Main St, New York, NY",
    salary: 5000.00,
    is_tax: true
  },
  {
    code: "EMP-002",
    name: "Brian Lee",
    department: "Product",
    position: "Product Manager",
    email: "brian.lee@yourmom.com",
    phone: "+1-555-0102",
    address: "456 Pine Ave, San Francisco, CA",
    salary: 30000.00,
    is_tax: true
  },
  {
    code: "EMP-003",
    name: "Carla Gomez",
    department: "Design",
    position: "UI Designer",
    email: "carla.gomez@yourmom.com",
    phone: "+1-555-0103",
    address: "789 Oak Blvd, Austin, TX",
    salary: 45000.00,
    is_tax: false
  },
  {
    code: "EMP-004",
    name: "Anaconde Sung",
    department: "Human Resources",
    position: "HR Specialist",
    email: "anaconde@yourmom.com",
    phone: "+1-555-0104",
    address: "777 Bang sue, Bangkok, BKK",
    salary: 50000.00,
    is_tax: true
  },
  {
    code: "EMP-005",
    name: "Sung Jin woo",
    department: "Operations",
    position: "Operations Lead",
    email: "im_the_best@yourmom.com",
    phone: "+1-555-0107",
    address: "999 Myeongdong, Seoul, KR",
    salary: 95000.00,
    is_tax: true
  },
  {
    code: "EMP-006",
    name: "David Smith",
    department: "Engineering",
    position: "DevOps Engineer",
    email: "david.smith@yourmom.com",
    phone: "+1-555-0105",
    address: "321 Maple Rd, Seattle, WA",
    salary: 45000.00,
    is_tax: true
  }

]

employees.each do |employee_attributes|
  employee = Employee.find_or_initialize_by(code: employee_attributes[:code])
  employee.update!(employee_attributes)
end
