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

  test "should check in an employee" do
    # Arrange & Act
    assert_difference("Attendance.count", 1) do
      post check_in_attendance_url(@employee)
    end

    # Assert
    attendance = Attendance.last
    assert_redirected_to employee_attendance_url(@employee)
    assert_not_nil attendance.check_in
    assert_nil attendance.check_out
    assert_equal "Checked in successfully.", flash[:notice]
  end

  test "should check out an employee and update latest record" do
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

  test "should return error notice if checking out without active check-in" do
    # Arrange (no active check-in)

    # Act
    patch check_out_attendance_url(@employee)

    # Assert
    assert_redirected_to employee_attendance_url(@employee)
    assert_equal "No active check-in found.", flash[:notice]
  end

  test "should allow checking out of an overnight shift (record from yesterday)" do
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

  test "should block double check-in on the same calendar day" do
    # Arrange: already checked in and out today
    today_in = Time.current.beginning_of_day + 8.hours
    today_out = today_in + 8.hours
    @employee.attendances.create!(check_in: today_in, check_out: today_out, timestamp: today_out)

    # Act
    post check_in_attendance_url(@employee)

    # Assert
    assert_redirected_to employee_attendance_url(@employee)
    assert_equal "You've already completed attendance for today.", flash[:alert]
  end
end
