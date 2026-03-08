require "test_helper"

class EmployeeControllerTest < ActionDispatch::IntegrationTest
  setup do
    @employee = Employee.create!(
      name: "Controller Test",
      code: "CTRL001",
      department: "Engineering",
      position: "Developer",
      email: "ctrl@example.com",
      phone: "123456",
      address: "123 Test St",
      salary: 50000,
      is_tax: true
    )
  end

  test "admin should get show_all (root)" do
    # Arrange
    post sign_in_path, params: { role: "admin" }

    # Act
    get admin_root_url

    # Assert
    assert_response :success
  end

  test "admin should get new employee form" do
    # Arrange
    post sign_in_path, params: { role: "admin" }

    # Act
    get new_admin_employee_url

    # Assert
    assert_response :success
  end

  test "admin should create employee" do
    # Arrange
    post sign_in_path, params: { role: "admin" }
    params = {
      employee: {
        name: "New Employee",
        code: "NEW001",
        department: "HR",
        position: "Manager",
        email: "new@example.com",
        phone: "999",
        address: "999 St",
        salary: 40000,
        is_tax: false
      }
    }

    # Act
    assert_difference("Employee.count", 1) do
      post admin_employees_url, params: params
    end

    # Assert
    assert_redirected_to admin_root_url
    assert_equal "Employee created successfully.", flash[:notice]
  end

  test "admin should show employee details" do
    # Arrange
    post sign_in_path, params: { role: "admin" }

    # Act
    get admin_employee_url(@employee)

    # Assert
    assert_response :success
  end

  test "admin should get edit employee form" do
    # Arrange
    post sign_in_path, params: { role: "admin" }

    # Act
    get edit_admin_employee_url(@employee)

    # Assert
    assert_response :success
  end

  test "admin should update employee" do
    # Arrange
    post sign_in_path, params: { role: "admin" }
    update_params = { employee: { name: "Updated Name", salary: 55000, is_tax: true } }

    # Act
    patch admin_employee_url(@employee), params: update_params

    # Assert
    assert_redirected_to admin_root_url
    @employee.reload
    assert_equal "Updated Name", @employee.name
  end

  test "admin should destroy employee" do
    # Arrange
    post sign_in_path, params: { role: "admin" }

    # Act
    assert_difference("Employee.count", -1) do
      delete admin_employee_url(@employee)
    end

    # Assert
    assert_redirected_to admin_root_url
  end

  test "employee should be denied access to all admin employee management" do
    # Arrange
    delete sign_out_path
    post sign_in_path, params: { employee_code: @employee.code, employee_name: @employee.name }

    # Act & Assert
    get admin_employees_url
    assert_redirected_to sign_in_option_path

    get admin_root_url
    assert_redirected_to sign_in_option_path

    get new_admin_employee_url
    assert_redirected_to sign_in_option_path

    post admin_employees_url, params: { employee: { name: "Hack" } }
    assert_redirected_to sign_in_option_path

    get admin_employee_url(@employee)
    assert_redirected_to sign_in_option_path

    get edit_admin_employee_url(@employee)
    assert_redirected_to sign_in_option_path

    patch admin_employee_url(@employee), params: { employee: { name: "Hack" } }
    assert_redirected_to sign_in_option_path

    delete admin_employee_url(@employee)
    assert_redirected_to sign_in_option_path

    assert_equal "Access denied", flash[:alert]
  end
end
