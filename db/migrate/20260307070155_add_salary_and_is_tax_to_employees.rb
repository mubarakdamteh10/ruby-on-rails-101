class AddSalaryAndIsTaxToEmployees < ActiveRecord::Migration[8.1]
  def change
    add_column :employees, :salary, :decimal, precision: 10, scale: 2
    add_column :employees, :is_tax, :boolean, default: true
  end
end
