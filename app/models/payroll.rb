class Payroll < ApplicationRecord
  belongs_to :employee, primary_key: :code, foreign_key: :employee_code

  scope :for_month, ->(month, year) { where(month: month, year: year) }
end
