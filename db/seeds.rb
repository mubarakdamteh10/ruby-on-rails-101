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

# --- Attendance Seed Data ---

attendances_data = [
  { employee_code: "EMP-001", check_in: "2026-03-07T03:35:27Z", check_out: "2026-03-07T13:35:30Z", over_time_hour: 2 },
  { employee_code: "EMP-001", check_in: "2026-03-06T03:35:27Z", check_out: "2026-03-06T13:35:30Z", over_time_hour: 2 },
  { employee_code: "EMP-001", check_in: "2026-03-05T03:35:27Z", check_out: "2026-03-05T13:35:30Z", over_time_hour: 2 },
  { employee_code: "EMP-002", check_in: "2026-03-06T03:43:18Z", check_out: "2026-03-06T13:43:19Z", over_time_hour: 2 },
  { employee_code: "EMP-002", check_in: "2026-03-05T03:43:18Z", check_out: "2026-03-05T13:43:19Z", over_time_hour: 2 },
  { employee_code: "EMP-002", check_in: "2026-03-04T08:00:00Z", check_out: "2026-03-04T17:00:00Z", over_time_hour: 1 }, # Standard day
  { employee_code: "EMP-003", check_in: "2026-03-06T03:46:13Z", check_out: "2026-03-06T13:46:13Z", over_time_hour: 2 },
  { employee_code: "EMP-003", check_in: "2026-03-05T03:46:13Z", check_out: "2026-03-05T13:46:13Z", over_time_hour: 2 },
  { employee_code: "EMP-003", check_in: "2026-03-07T03:46:13Z", check_out: "2026-03-07T13:46:13Z", over_time_hour: 2 },
  { employee_code: "EMP-004", check_in: "2026-03-07T08:00:00Z", check_out: "2026-03-07T20:00:00Z", over_time_hour: 4 }, # High OT
  { employee_code: "EMP-004", check_in: "2026-03-06T08:00:00Z", check_out: "2026-03-06T17:00:00Z", over_time_hour: 0 },
  { employee_code: "EMP-005", check_in: "2026-03-07T09:00:00Z", check_out: "2026-03-07T18:00:00Z", over_time_hour: 1 },
  { employee_code: "EMP-006", check_in: "2026-03-07T08:30:00Z", check_out: "2026-03-07T17:30:00Z", over_time_hour: 1 }
]

attendances_data.each do |data|
  check_in_time = Time.zone.parse(data[:check_in])

  # Find or create by employee and date
  attendance = Attendance.find_or_initialize_by(
    employee_code: data[:employee_code],
    check_in: check_in_time.beginning_of_day..check_in_time.end_of_day
  )

  attendance.check_in = check_in_time
  attendance.check_out = data[:check_out] ? Time.zone.parse(data[:check_out]) : nil
  attendance.over_time_hour = data[:over_time_hour]
  attendance.save!
end

puts "Seed data created successfully: #{Employee.count} employees, #{Attendance.count} attendances."
