class SalaryController < ApplicationController
  def calculator
    # If logged in as employee, pre-fill base salary
    @default_salary = current_employee&.salary || 0
  end
end
