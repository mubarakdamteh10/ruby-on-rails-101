class PayrollController < ApplicationController
  before_action :ensure_admin!, only: [ :index, :calculate ]
  before_action :ensure_logged_in!

  def employee_index
    @payrolls = Payroll.where(employee_code: session[:employee_code]).order(year: :desc, month: :desc)
  end

  def index
    @month = params[:month]&.to_i || Time.current.month
    @year = params[:year]&.to_i || Time.current.year

    @employees = Employee.all.order(:name)
    @payrolls = Payroll.for_month(@month, @year)
  end

  def calculate
    month = params[:month]&.to_i || Time.current.month
    year = params[:year]&.to_i || Time.current.year

    Employee.find_each do |employee|
      data = employee.current_payroll_data(month, year)

      # Update or create payroll record for this month
      payroll = Payroll.find_or_initialize_by(
        employee_code: employee.code,
        month: month,
        year: year
      )

      payroll.base_salary = data[:base_salary]
      payroll.total_ot_hours = data[:total_ot_hours]
      payroll.total_worked_days = data[:total_worked_days].to_i
      payroll.ot_payment = data[:ot_payment]
      payroll.gross_salary = data[:gross_composition]
      payroll.tax_percentage = data[:tax_percentage]
      payroll.tax_amount = data[:tax_amount]
      payroll.net_amount = data[:net_amount]

      payroll.save
    end

    redirect_to admin_payroll_index_path(month: month, year: year), notice: "Payroll calculated successfully for #{Date::MONTHNAMES[month]} #{year}."
  end

  private

  def ensure_admin!
    redirect_to sign_in_option_path, alert: "Access denied" unless admin?
  end

  def ensure_logged_in!
    redirect_to sign_in_option_path, alert: "Please sign in first" unless current_user_role.present?
  end
end
