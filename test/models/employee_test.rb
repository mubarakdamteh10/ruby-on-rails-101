require "test_helper"

class EmployeeTest < ActiveSupport::TestCase
  setup do
    @employee = Employee.new(
      name: "Test User",
      code: "TEST01",
      department: "Test Dept",
      position: "Tester",
      email: "test@test.com",
      phone: "123456",
      address: "Test Address",
      salary: 30000,
      is_tax: true
    )
  end

  # --- OT Calculation Tests ---

  test "calculate_ot_payment returns correct amount based on 240 hour basis" do
    # Formula: 30000 / 240 = 125 per hour
    # 10 hours should be 1250
    ot_payment = @employee.calculate_ot_payment(10)
    assert_equal 1250.0, ot_payment
  end

  test "calculate_ot_payment returns 0 for 0 hours" do
    assert_equal 0, @employee.calculate_ot_payment(0)
  end

  # --- Tax Level Tests ---

  test "tax level is 0% for gross salary <= 30000" do
    tax_info = @employee.calculate_tax_level(30000)
    assert_equal 0, tax_info[:percentage]
    assert_equal 0, tax_info[:amount]
  end

  test "tax level is 5% for gross salary between 30001 and 50000" do
    # 40000 * 5% = 2000
    tax_info = @employee.calculate_tax_level(40000)
    assert_equal 5, tax_info[:percentage]
    assert_equal 2000.0, tax_info[:amount]
  end

  test "tax level is 10% for gross salary >= 50001" do
    # 60000 * 10% = 6000
    tax_info = @employee.calculate_tax_level(60000)
    assert_equal 10, tax_info[:percentage]
    assert_equal 6000.0, tax_info[:amount]
  end

  test "tax level is always 0% when is_tax is false" do
    @employee.is_tax = false
    tax_info = @employee.calculate_tax_level(100000)
    assert_equal 0, tax_info[:percentage]
    assert_equal 0, tax_info[:amount]
  end

  # --- Comprehensive Payroll Data Tests ---

  test "current_payroll_data calculates final net amount correctly for mid-tier salary with OT" do
    # Arrange
    @employee.salary = 40000
    @employee.is_tax = true
    @employee.save!

    # Create 10 hours of overtime for the current month
    # We'll create 10 records of 1 hour overtime each
    10.times do |i|
      Attendance.create!(
        employee: @employee,
        check_in: Time.current.beginning_of_month + i.days + 8.hours,
        check_out: Time.current.beginning_of_month + i.days + 17.hours, # 9 hours total = 1 hour OT
        over_time_hour: 1
      )
    end

    # Act
    data = @employee.current_payroll_data

    # Assert
    # Base: 40000
    # OT: 10 * (40000 / 240.0) = 1666.67
    # Gross: 41666.67
    # Tax: 41666.67 * 5% = 2083.33
    # Net: 41666.67 - 2083.33 = 39583.34

    expected_ot_pay = (10 * (40000 / 240.0)).round(2)
    expected_gross = 40000 + expected_ot_pay
    expected_tax = (expected_gross * 0.05).round(2)
    expected_net = expected_gross - expected_tax

    assert_equal 10, data[:total_ot_hours]
    assert_equal expected_ot_pay, data[:ot_payment]
    assert_equal expected_tax, data[:tax_amount]
    assert_equal expected_net, data[:net_amount]
  end

  test "current_payroll_data calculates final net amount correctly for high-tier salary without tax" do
    # Arrange
    @employee.salary = 80000
    @employee.is_tax = false
    @employee.save!

    # Act
    data = @employee.current_payroll_data

    # Assert
    assert_equal 80000.0, data[:base_salary]
    assert_equal 0, data[:ot_payment]
    assert_equal 0, data[:tax_amount]
    assert_equal 80000.0, data[:net_amount]
  end
end
