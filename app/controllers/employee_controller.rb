
# get all 
get "/employees", to: "employee#index"
def get_all_employees
    employees = Employee.all
    render json: employees
end
# get by employee_id
get "/employees/:id", to: "employee#show"
def get_employee_by_id
    employee = Employee.find(params[:id])
    render json: employee
end
# create employee
post "/employees", to: "employee#create"
def create_employee
    employee = Employee.create(params)
    render json: employee
end
# update employee
put "/employees/:id", to: "employee#update"
def update_employee
    employee = Employee.find(params[:id])
    employee.update(params)
    render json: employee
end
# delete employee
delete "/employees/:id", to: "employee#destroy"
def delete_employee
    employee = Employee.find(params[:id])
    employee.destroy
    render json: { message: "Employee deleted successfully" }
end