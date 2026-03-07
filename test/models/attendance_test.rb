require "test_helper"

class AttendanceTest < ActiveSupport::TestCase
  test "calculate_duration returns 0h 0m for same check-in and check-out" do
    # Arrange
    base_time = Time.zone.parse("2026-03-07 10:00:00")

    # Act
    result = Attendance.calculate_duration(base_time, base_time)

    # Assert
    assert_equal "0h 0m", result
  end

  test "calculate_duration handles hours and minutes correctly" do
    # Arrange
    base_time = Time.zone.parse("2026-03-07 10:00:00")
    check_out = base_time + 1.hour + 2.minutes

    # Act
    result = Attendance.calculate_duration(base_time, check_out)

    # Assert
    assert_equal "1h 2m", result
  end

  test "calculate_duration handles long durations" do
    # Arrange
    base_time = Time.zone.parse("2026-03-07 10:00:00")
    check_out = base_time + 12.hours + 7.minutes

    # Act
    result = Attendance.calculate_duration(base_time, check_out)

    # Assert
    assert_equal "12h 7m", result
  end

  test "calculate_duration ignores remaining seconds (rounds down)" do
    # Arrange
    base_time = Time.zone.parse("2026-03-07 10:00:00")
    check_out = base_time + 1.minute + 59.seconds

    # Act
    result = Attendance.calculate_duration(base_time, check_out)

    # Assert
    assert_equal "0h 1m", result
  end

  test "calculate_duration returns nil if times are missing" do
    # Arrange
    check_in = nil
    check_out = Time.current

    # Act
    result = Attendance.calculate_duration(check_in, check_out)

    # Assert
    assert_nil result
  end

  test "automatically calculates metrics on save" do
    # Arrange
    employee = mock_employee
    check_in = Time.zone.parse("2026-03-07 09:00:00")
    check_out = check_in + 2.hours

    # Act
    attendance = Attendance.create!(
      employee: employee,
      check_in: check_in,
      check_out: check_out
    )

    # Assert
    assert_equal "2h 0m", attendance.duration
    assert_equal 0, attendance.over_time_hour
  end

  test "sets overtime to 1 when duration is 9 hours" do
    # Arrange
    employee = mock_employee
    check_in = Time.zone.parse("2026-03-07 08:00:00")
    check_out = check_in + 9.hours # 9h 0m

    # Act
    attendance = Attendance.create!(
      employee: employee,
      check_in: check_in,
      check_out: check_out
    )

    # Assert
    assert_equal "9h 0m", attendance.duration
    assert_equal 1, attendance.over_time_hour
  end

  test "sets overtime to 0 when duration is exactly 8 hours" do
    # Arrange
    employee = mock_employee
    check_in = Time.zone.parse("2026-03-07 08:00:00")
    check_out = check_in + 8.hours

    # Act
    attendance = Attendance.create!(
      employee: employee,
      check_in: check_in,
      check_out: check_out
    )

    # Assert
    assert_equal "8h 0m", attendance.duration
    assert_equal 0, attendance.over_time_hour
  end

  private

  def mock_employee
    Employee.create!(
      name: "Test Employee",
      code: "EMP#{SecureRandom.hex(4)}",
      department: "Engineering",
      position: "Developer",
      email: "test@example.com",
      phone: "1234567890",
      address: "123 Test St"
    )
  end
end
