require "application_system_test_case"

class SalaryEstimatorFlowTest < ApplicationSystemTestCase
  setup do
    @alice = employees(:alice) # Base salary 5000 (from fixtures)
  end

  test "employee can use salary estimator" do
    # 1. Sign in as Alice
    visit root_path
    click_on @alice.name
    pause_for_human

    # 2. Navigate to Salary Estimator
    click_on "Salary Estimator"
    pause_for_human

    # 3. Verify pre-filled base salary
    # The input has id "base_salary"
    assert_field "base_salary", with: "5000.0"

    # Initial calculation (tax enabled by default)
    # 5000 * (1 - 0.0) = 5000.00
    assert_text "5,000.00 ฿"
    assert_text "Tax (0%)"

    # 4. Input OT hours
    fill_in "ot_hours", with: "10"
    pause_for_human

    # 5. Calculate
    click_on "Calculate Now"
    pause_for_human

    # 6. Verify updated results
    # Hourly rate = 5000 / 240 = 20.833
    # OT Pay = 10 * 20.833 = 208.33
    # Gross = 5000 + 208.33 = 5208.33
    # Tax = 0 (Base <= 30000)
    assert_text "5,208.33 ฿"
    assert_text "+ 208.33 ฿"

    # 7. Test Tax Logic with 40k Salary
    fill_in "base_salary", with: "40000"
    fill_in "ot_hours", with: "0"

    # Ensure Tax is ON (it was toggled OFF in previous step, so toggle it back ON)
    # The net salary for 40k with 5% tax should be 38k
    click_on "Calculate Now"
    assert_text "38,000.00 ฿"
    assert_text "Tax (5%)"
    pause_for_human

    # 8. Verify Tax Toggle OFF
    click_on "tax_toggle"
    # Net should now be 40000.00 (Tax 0%)
    assert_text "40,000.00 ฿"
    assert_text "Tax (0%)"
    pause_for_human
  end
end
