class EmployeeController < ApplicationController
  before_action :set_employee, only: [ :show, :edit, :update, :destroy ]

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
      redirect_to root_path, notice: "Employee created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end


  def update
    if @employee.update(employee_params)
      redirect_to root_path, notice: "Employee updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @employee.destroy
    redirect_to root_path, notice: "Employee deleted successfully."
  end

  private
  def set_employee
    @employee = Employee.find(params[:id])
  end

  private
  def employee_params
    params.require(:employee).permit(:employee_id, :code, :name, :email, :phone, :address, :department, :position, :salary, :is_tax)
  end
end
