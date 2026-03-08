class Payroll < ApplicationRecord
  self.primary_key = "payroll_id"
  belongs_to :employee, primary_key: :code, foreign_key: :employee_code

  scope :for_month, ->(month, year) { where(month: month, year: year) }

  def self.calculate_for_month!(month, year)
    Employee.find_each do |employee|
      data = employee.current_payroll_data(month, year)

      payroll = find_or_initialize_by(
        employee_code: employee.code,
        month: month,
        year: year
      )

      payroll.update!(
        base_salary: data[:base_salary],
        total_ot_hours: data[:total_ot_hours],
        total_worked_days: data[:total_worked_days].to_i,
        ot_payment: data[:ot_payment],
        gross_salary: data[:gross_composition],
        tax_percentage: data[:tax_percentage],
        tax_amount: data[:tax_amount],
        net_amount: data[:net_amount]
      )
    end
  end
end
