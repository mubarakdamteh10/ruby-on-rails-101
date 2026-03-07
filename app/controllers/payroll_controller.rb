class PayrollController < ApplicationController
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
      data = employee.current_payroll_data

      # Update or create payroll record for this month
      payroll = Payroll.find_or_initialize_by(
        employee_code: employee.code,
        month: month,
        year: year
      )

      payroll.update!(
        base_salary: data[:base_salary],
        total_ot_hours: data[:total_ot_hours],
        ot_payment: data[:ot_payment],
        gross_salary: data[:gross_composition],
        tax_percentage: data[:tax_percentage],
        tax_amount: data[:tax_amount],
        net_amount: data[:net_amount]
      )
    end

    redirect_to payroll_index_path(month: month, year: year), notice: "Payroll calculated successfully for #{Date::MONTHNAMES[month]} #{year}."
  end
end
