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

  test "should get show_all (root)" do
    # Arrange (Already handled in setup)

    # Act
    get root_url

    # Assert
    assert_response :success
  end

  test "should get new" do
    # Arrange (Already handled in setup)

    # Act
    get new_employee_url

    # Assert
    assert_response :success
  end

  test "should create employee" do
    # Arrange
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

    # Act & Assert
    assert_difference("Employee.count", 1) do
      post employees_url, params: params
    end

    # Assert (Session and redirection)
    assert_redirected_to root_url
    assert_equal "Employee created successfully.", flash[:notice]
  end

  test "should show employee" do
    # Arrange (Already handled in setup)

    # Act
    get employee_url(@employee)

    # Assert
    assert_response :success
  end

  test "should get edit" do
    # Arrange (Already handled in setup)

    # Act
    get edit_employee_url(@employee)

    # Assert
    assert_response :success
  end

  test "should update employee" do
    # Arrange
    update_params = { employee: { name: "Updated Name" } }

    # Act
    patch employee_url(@employee), params: update_params

    # Assert
    assert_redirected_to root_url
    @employee.reload
    assert_equal "Updated Name", @employee.name
  end

  test "should destroy employee" do
    # Arrange (Already handled in setup)

    # Act & Assert
    assert_difference("Employee.count", -1) do
      delete employee_url(@employee)
    end

    # Assert
    assert_redirected_to root_url
  end
end
