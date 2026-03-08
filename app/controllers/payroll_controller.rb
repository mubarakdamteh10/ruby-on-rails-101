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

    Payroll.calculate_for_month!(month, year)

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
