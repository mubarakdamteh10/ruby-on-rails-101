class EmployeeController < ApplicationController
  before_action :set_employee, only: [ :show, :edit, :update, :destroy ]
  before_action :ensure_admin!

  def index
    @employees = Employee.order(:employee_id)
  end

  def show_all
    @employees = Employee.order(:employee_id)
  end

  def new
    @employee = Employee.new
  end

  def edit
  end

  def create
    @employee = Employee.new(employee_params)

    if @employee.save
      redirect_to admin_root_path, notice: "Employee created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end


  def update
    if @employee.update(employee_params)
      redirect_to admin_root_path, notice: "Employee updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @employee.destroy
    redirect_to admin_root_path, notice: "Employee deleted successfully."
  end

  private

  def set_employee
    @employee = Employee.find_by!(code: params[:id])
  end

  def ensure_admin!
    redirect_to sign_in_option_path, alert: "Access denied" unless admin?
  end

  def employee_params
    params.require(:employee).permit(:employee_id, :code, :name, :email, :phone, :address, :department, :position, :salary, :is_tax)
  end
end
