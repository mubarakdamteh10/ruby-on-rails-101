require "test_helper"

class PayrollVisibilityTest < ActionDispatch::IntegrationTest
  setup do
    @employee = Employee.create!(
      name: "Alice Johnson",
      code: "EMP-VIS-001",
      department: "Engineering",
      position: "Developer",
      email: "alice@example.com",
      phone: "123",
      address: "123 St",
      salary: 50000,
      is_tax: true
    )
    @payroll = Payroll.create!(
      employee_code: @employee.code,
      month: 3,
      year: 2026,
      base_salary: 50000,
      total_ot_hours: 0,
      ot_payment: 0,
      gross_salary: 50000,
      tax_percentage: 5,
      tax_amount: 2500,
      net_amount: 47500
    )
  end

  test "employee can view their own payroll" do
    # Arrange
    post sign_in_path, params: { employee_code: @employee.code, employee_name: @employee.name }

    # Act
    get employee_payroll_path

    # Assert
    assert_response :success
    assert_select "h1", "My Payroll History"
    assert_select "h2", "March"
    assert_select "div", text: /47,500.00 ฿/
  end

  test "employee cannot view admin payroll index" do
    # Arrange
    post sign_in_path, params: { employee_code: @employee.code, employee_name: @employee.name }

    # Act
    get admin_payroll_index_path

    # Assert
    assert_redirected_to sign_in_option_path
    follow_redirect!
    assert_select "div", text: /Access denied/
  end

  test "logged out user cannot view payroll" do
    # Arrange (None needed - starting fresh)

    # Act
    get employee_payroll_path

    # Assert
    assert_redirected_to sign_in_option_path
  end

  test "admin can still view admin payroll index" do
    # Arrange
    post sign_in_path, params: { role: "admin" }

    # Act
    get admin_payroll_index_path

    # Assert
    assert_response :success
    assert_select "h1", "Payroll Management"
  end
end
