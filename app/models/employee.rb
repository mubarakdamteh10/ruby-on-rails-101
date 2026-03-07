class Employee < ApplicationRecord
  self.primary_key = "employee_id"
  has_many :attendances, primary_key: :code, foreign_key: :employee_code, dependent: :destroy

  validates :name, presence: true
  validates :code, presence: true, uniqueness: true
  validates :department, presence: true
  validates :position, presence: true
  validates :email, presence: true
  validates :phone, presence: true
  validates :address, presence: true
  # validates :created_by, presence: true
  # validates :updated_by, presence: true
  def to_param
    code
  end

  # --- Payroll Calculation Logic ---

  def total_ot_hours(month = Time.current.month, year = Time.current.year)
    start_date = Date.new(year, month, 1)
    end_date = start_date.end_of_month

    attendances.where(check_in: start_date.beginning_of_day..end_date.end_of_day).sum(:over_time_hour)
  end

  def calculate_ot_payment(ot_hours)
    return 0 if salary.blank? || ot_hours <= 0
    # Formula: OT Pay = OT Hours * (Salary / (30 days * 8 hours))
    # 30 * 8 = 240
    hourly_rate = salary / 240.0
    (ot_hours * hourly_rate).round(2)
  end

  def calculate_tax_level(gross_salary)
    return { percentage: 0, amount: 0 } unless is_tax

    # Logic:
    # - if base salary is less or equal to 30000 --- tax 0 %
    # - if base salary between 30001 - 50000 --- tax 5 %
    # - if base salary equal or more than 50001 --- tax 10 %

    percentage = case gross_salary
    when 0..30000 then 0
    when 30001..50000 then 5
    else 10
    end

    tax_amount = (gross_salary * (percentage / 100.0)).round(2)
    { percentage: percentage, amount: tax_amount }
  end

  def current_payroll_data
    month = Time.current.month
    year = Time.current.year

    ot_hours = total_ot_hours(month, year)
    ot_pay = calculate_ot_payment(ot_hours)
    gross = (salary || 0) + ot_pay
    tax_info = calculate_tax_level(gross)
    net = gross - tax_info[:amount]

    {
      base_salary: salary || 0,
      total_ot_hours: ot_hours,
      ot_payment: ot_pay,
      gross_composition: gross,
      tax_percentage: tax_info[:percentage],
      tax_amount: tax_info[:amount],
      net_amount: net,
      month: month,
      year: year
    }
  end

  # --- End Payroll Calculation Logic ---

  def as_json(options = {})
    super(options).merge(
      "created_at" => created_at&.utc&.strftime("%Y-%m-%dT%H:%M:%S%:z"),
      "updated_at" => updated_at&.utc&.strftime("%Y-%m-%dT%H:%M:%S%:z")
    )
  end
end
