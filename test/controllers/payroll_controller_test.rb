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
  end

  test "should get index" do
    # Arrange (Already handled in setup)

    # Act
    get payroll_index_url

    # Assert
    assert_response :success
  end

  test "should calculate payroll" do
    # Arrange
    month = Time.current.month
    year = Time.current.year

    # Act
    assert_difference("Payroll.count", 1) do
      post calculate_payroll_index_url, params: { month: month, year: year }
    end

    # Assert
    assert_redirected_to payroll_index_url(month: month, year: year)
    assert_equal "Payroll calculated successfully for #{Date::MONTHNAMES[month]} #{year}.", flash[:notice]

    payroll = Payroll.find_by(employee_code: @employee.code, month: month, year: year)
    assert_not_nil payroll
    assert_equal 60000.0, payroll.base_salary
  end

  test "should update existing payroll on recalculation" do
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
    assert_no_difference("Payroll.count") do
      post calculate_payroll_index_url, params: { month: month, year: year }
    end

    # Assert
    payroll = Payroll.find_by(employee_code: @employee.code, month: month, year: year)
    # It should be updated to real salary 60000
    assert_equal 60000.0, payroll.base_salary
  end
end
