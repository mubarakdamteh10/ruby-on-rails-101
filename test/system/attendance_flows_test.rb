require "application_system_test_case"

class AttendanceFlowTest < ApplicationSystemTestCase
  setup do
    @alice = employees(:alice)
  end

  test "employee can check in and check out" do
    # 1. Sign in as Alice
    visit root_path
    pause_for_human

    # The login page has buttons with employee names
    click_on @alice.name
    pause_for_human

    # 2. Verify we are on the attendance page
    # The view shows the employee name in an h1 (line 14)
    assert_selector "h1", text: @alice.name
    assert_text "Not Checked In"
    assert_button "Check In"

    # 3. Check In
    click_on "Check In"
    pause_for_human

    # 4. Assert check-in success
    # Note: Flash messages are not rendered in application.html.erb,
    # so we assert based on the UI state change.
    assert_text "You are Checked In"
    assert_button "Check Out"
    assert_no_button "Check In"

    # 5. Check Out
    click_on "Check Out"
    pause_for_human

    # 6. Assert check-out success
    assert_text "Today's Attendance Completed!"
    assert_text "ATTENDANCE RECORDED"
    assert_no_button "Check Out"
    assert_no_button "Check In"
    pause_for_human
  end
end
