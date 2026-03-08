require "test_helper"

class AttendancesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @employee = Employee.create!(
      code: "CTRL-001",
      name: "Controller Test",
      email: "ctrl@test.com",
      phone: "123",
      address: "123 St",
      department: "QA",
      position: "Tester"
    )
    # Sign in as the employee
    post sign_in_path(employee_code: @employee.code, employee_name: @employee.name)
  end

  test "employee should check in successfully" do
    # Arrange
    # Employee is already signed in via setup

    # Act
    assert_difference("@employee.attendances.count", 1) do
      post check_in_attendance_url(@employee)
    end

    # Assert
    attendance = @employee.attendances.order(:created_at).last
    assert_redirected_to employee_attendance_url(@employee)
    assert_not_nil attendance.check_in
    assert_nil attendance.check_out
    assert_equal "Checked in successfully.", flash[:notice]
  end

  test "employee should check out successfully and update latest record" do
    # Arrange
    attendance = @employee.attendances.create!(check_in: 1.hour.ago, timestamp: 1.hour.ago)

    # Act
    patch check_out_attendance_url(@employee)

    # Assert
    attendance.reload
    assert_redirected_to employee_attendance_url(@employee)
    assert_not_nil attendance.check_out
    assert_not_nil attendance.duration
    assert_equal "Checked out successfully.", flash[:notice]
  end

  test "employee should receive error notice if checking out without active check-in" do
    # Arrange
    # (No active check-in exists)

    # Act
    patch check_out_attendance_url(@employee)

    # Assert
    assert_redirected_to employee_attendance_url(@employee)
    assert_equal "No active check-in found.", flash[:notice]
  end

  test "employee should be able to check out of an overnight shift (record from yesterday)" do
    # Arrange
    yesterday_in = 20.hours.ago
    attendance = @employee.attendances.create!(check_in: yesterday_in, timestamp: yesterday_in)

    # Act
    patch check_out_attendance_url(@employee)

    # Assert
    attendance.reload
    assert_not_nil attendance.check_out
    assert_equal "Checked out successfully.", flash[:notice]
  end

  test "employee should be blocked from double check-in on the same calendar day" do
    # Arrange (Already checked in and out today)
    today_in = Time.current.beginning_of_day + 8.hours
    today_out = today_in + 8.hours
    @employee.attendances.create!(check_in: today_in, check_out: today_out, timestamp: today_out)

    # Act
    post check_in_attendance_url(@employee)

    # Assert
    assert_redirected_to employee_attendance_url(@employee)
    assert_equal "You've already completed attendance for today.", flash[:alert]
  end

  test "employee should be denied access to admin attendance index" do
    # Arrange
    # (Employee is signed in via setup)

    # Act
    get admin_attendances_url

    # Assert
    assert_redirected_to sign_in_option_path
    assert_equal "Access denied", flash[:alert]
  end

  test "employee should be denied access to another employee's attendance page" do
    # Arrange
    other_employee = Employee.create!(
      code: "OTHER", name: "Other", email: "other@test.com", phone: "0", address: "X", department: "D", position: "P"
    )

    # Act
    get employee_attendance_url(other_employee)

    # Assert
    assert_redirected_to sign_in_option_path
    assert_equal "Access denied. You can only view your own attendance.", flash[:alert]
  end

  test "employee should be denied check-in for another employee" do
    # Arrange
    other_employee = Employee.create!(
      code: "OTHER2", name: "Other2", email: "other2@test.com", phone: "0", address: "X", department: "D", position: "P"
    )

    # Act
    post check_in_attendance_url(other_employee)

    # Assert
    assert_redirected_to sign_in_option_path
    assert_equal "Access denied. You can only view your own attendance.", flash[:alert]
  end
end
