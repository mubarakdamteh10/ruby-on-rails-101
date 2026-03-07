class CreatePayrolls < ActiveRecord::Migration[8.1]
  def change
    create_table :payrolls do |t|
      t.string :employee_code
      t.integer :month
      t.integer :year
      t.decimal :base_salary, precision: 10, scale: 2
      t.decimal :total_ot_hours, precision: 10, scale: 2
      t.decimal :ot_payment, precision: 10, scale: 2
      t.decimal :gross_salary, precision: 10, scale: 2
      t.decimal :tax_percentage, precision: 5, scale: 2
      t.decimal :tax_amount, precision: 10, scale: 2
      t.decimal :net_amount, precision: 10, scale: 2

      t.timestamps
    end
  end
end
