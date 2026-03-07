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

  # --- CRUD & Validation Tests ---

  test "should create a valid employee" do
    assert @employee.valid?
    assert_difference "Employee.count", 1 do
      @employee.save
    end
  end

  test "should update an employee's salary and position" do
    @employee.save!
    @employee.update(salary: 55000, position: "Senior Tester")

    @employee.reload
    assert_equal 55000, @employee.salary
    assert_equal "Senior Tester", @employee.position
  end

  test "should not be valid without a name" do
    @employee.name = nil
    assert_not @employee.valid?
    assert_includes @employee.errors[:name], "can't be blank"
  end

  test "should not be valid without an employee code" do
    @employee.code = nil
    assert_not @employee.valid?
    assert_includes @employee.errors[:code], "can't be blank"
  end

  test "should not be valid without a department" do
    @employee.department = nil
    assert_not @employee.valid?
  end

  test "should not allow duplicate employee codes" do
    @employee.save!
    duplicate = @employee.dup
    assert_not duplicate.valid?
    assert_includes duplicate.errors[:code], "has already been taken"
  end

  # --- Robust Payroll Boundary Tests ---

  test "tax boundary: exactly 30000 base should be 0% even with OT" do
    tax_info = @employee.calculate_tax_level(30000, 35000)

    # Assert
    # Base: 30000
    # OT: 5000
    # Gross: 35000
    # Tax Tier: 30000 base -> 0%
    # Tax: 35000 * 0% = 0
    # Net: 35000 - 0 = 35000
    assert_equal 0, tax_info[:percentage]
    assert_equal 0, tax_info[:amount]
  end

  test "tax boundary: 30001 base should be 5%" do
    tax_info = @employee.calculate_tax_level(30001, 30001)

    # Assert
    # Base: 30001
    # OT: 0
    # Gross: 30001
    # Tax Tier: 30001 base -> 5%
    # Tax: 30001 * 5% = 1500.05
    # Net: 30001 - 1500.05 = 28500.95
    assert_equal 5, tax_info[:percentage]
  end

  test "tax boundary: exactly 50000 base should be 5%" do
    tax_info = @employee.calculate_tax_level(50000, 50000)

    # Assert
    # Base: 50000
    # OT: 0
    # Gross: 50000
    # Tax Tier: 50000 base -> 5%
    # Tax: 50000 * 5% = 2500
    # Net: 50000 - 2500 = 47500
    assert_equal 5, tax_info[:percentage]
  end

  test "tax boundary: 50001 base should be 10%" do
    tax_info = @employee.calculate_tax_level(50001, 50001)

    # Assert
    # Base: 50001
    # OT: 0
    # Gross: 50001
    # Tax Tier: 50001 base -> 10%
    # Tax: 50001 * 10% = 5000.1
    # Net: 50001 - 5000.1 = 45000.9
    assert_equal 10, tax_info[:percentage]
  end

  test "payroll handles zero salary correctly" do
    @employee.salary = 0
    data = @employee.current_payroll_data
    assert_equal 0, data[:net_amount]
    assert_equal 0, data[:ot_payment]
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

  test "tax level is 0% for base salary <= 30000" do
    tax_info = @employee.calculate_tax_level(30000, 35000)

    # Assert
    # Base: 30000
    # OT: 5000
    # Gross: 35000
    # Tax Tier: 30000 base -> 0%
    # Tax: 35000 * 0% = 0
    # Net: 35000 - 0 = 35000
    assert_equal 0, tax_info[:percentage]
    assert_equal 0, tax_info[:amount]
  end

  test "tax level is 5% for base salary between 30001 and 50000" do
    tax_info = @employee.calculate_tax_level(40000, 45000)

    # Assert
    # Base: 40000
    # OT: 5000
    # Gross: 45000
    # Tax Tier: 40000 base -> 5%
    # Tax: 45000 * 5% = 2250
    # Net: 45000 - 2250 = 42750
    assert_equal 5, tax_info[:percentage]
    assert_equal 2250.0, tax_info[:amount]
  end

  test "tax level is 10% for base salary >= 50001" do
    tax_info = @employee.calculate_tax_level(60000, 70000)

    # Assert
    # Base: 60000
    # OT: 10000
    # Gross: 70000
    # Tax Tier: 60000 base -> 10%
    # Tax: 70000 * 10% = 7000
    # Net: 70000 - 7000 = 63000
    assert_equal 10, tax_info[:percentage]
    assert_equal 7000.0, tax_info[:amount]
  end

  test "tax level is always 0% when is_tax is false" do
    @employee.is_tax = false
    tax_info = @employee.calculate_tax_level(100000, 110000)

    # Assert
    # Base: 100000
    # OT: 10000
    # Gross: 110000
    # Tax Tier: is_tax is false -> 0%
    # Tax: 110000 * 0% = 0
    # Net: 110000 - 0 = 110000
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
    # Tax Tier: 40000 base -> 5%
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
