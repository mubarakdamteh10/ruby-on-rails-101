class ChangePayrollsToUuid < ActiveRecord::Migration[8.1]
  def change
    drop_table :payrolls if table_exists?(:payrolls)

    create_table :payrolls, primary_key: "payroll_id", id: :uuid, default: -> { "gen_random_uuid()" } do |t|
      t.string :employee_code, null: false
      t.integer :month, null: false
      t.integer :year, null: false
      t.decimal :base_salary, precision: 10, scale: 2
      t.decimal :total_ot_hours, precision: 10, scale: 2
      t.decimal :ot_payment, precision: 10, scale: 2
      t.decimal :gross_salary, precision: 10, scale: 2
      t.decimal :tax_percentage, precision: 5, scale: 2
      t.decimal :tax_amount, precision: 10, scale: 2
      t.decimal :net_amount, precision: 10, scale: 2

      t.timestamps
    end

    add_index :payrolls, :employee_code
    add_index :payrolls, [ :employee_code, :month, :year ], unique: true
  end
end
