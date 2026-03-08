require "test_helper"

class PayrollControllerTest < ActionDispatch::IntegrationTest
  setup do
    @employee = Employee.create!(
      name: "Payroll Test",
      code: "PAY001",
      department: "Finance",
      position: "Accountant",
      email: "pay@example.com",
      phone: "123",
      address: "123 St",
      salary: 60000,
      is_tax: true
    )
    @attendance = Attendance.create!(
      employee_code: @employee.code,
      check_in: Time.current.beginning_of_day + 8.hours,
      check_out: Time.current.beginning_of_day + 17.hours
    )
    # Mock admin session
    post sign_in_path, params: { role: "admin" }
  end

  test "admin should get index" do
    # Arrange (Already handled in setup)

    # Act
    get admin_payroll_index_url

    # Assert
    assert_response :success
  end

  test "admin should calculate payroll" do
    # Arrange
    month = Time.current.month
    year = Time.current.year

    # Act
    assert_difference("Payroll.where(employee_code: @employee.code).count", 1) do
      post calculate_admin_payroll_index_url, params: { month: month, year: year }
    end

    # Assert
    assert_redirected_to admin_payroll_index_url(month: month, year: year)
    assert_equal "Payroll calculated successfully for #{Date::MONTHNAMES[month]} #{year}.", flash[:notice]

    payroll = Payroll.find_by(employee_code: @employee.code, month: month, year: year)
    assert_not_nil payroll
    assert_equal 60000.0, payroll.base_salary
    assert_equal 1, payroll.total_worked_days
  end

  test "admin should update existing payroll on recalculation" do
    # Arrange
    month = Time.current.month
    year = Time.current.year

    Payroll.create!(
      employee_code: @employee.code,
      month: month,
      year: year,
      base_salary: 1000,
      total_ot_hours: 0,
      ot_payment: 0,
      gross_salary: 1000,
      tax_percentage: 0,
      tax_amount: 0,
      net_amount: 1000
    )

    # Act
    assert_no_difference("Payroll.where(employee_code: @employee.code).count") do
      post calculate_admin_payroll_index_url, params: { month: month, year: year }
    end

    # Assert
    payroll = Payroll.find_by(employee_code: @employee.code, month: month, year: year)

    # It should be updated to real salary 60000
    assert_equal 60000.0, payroll.base_salary
  end

  test "employee should be denied access to admin payroll index" do
    # Arrange
    delete sign_out_path # Use delete as defined in routes.rb
    post sign_in_path, params: { employee_code: @employee.code, employee_name: @employee.name }

    # Act
    get admin_payroll_index_url

    # Assert
    assert_redirected_to sign_in_option_path
    assert_equal "Access denied", flash[:alert]
  end

  test "employee should be denied access to calculate payroll" do
    # Arrange
    delete sign_out_path
    post sign_in_path, params: { employee_code: @employee.code, employee_name: @employee.name }

    # Act
    post calculate_admin_payroll_index_url

    # Assert
    assert_redirected_to sign_in_option_path
    assert_equal "Access denied", flash[:alert]
  end
end
