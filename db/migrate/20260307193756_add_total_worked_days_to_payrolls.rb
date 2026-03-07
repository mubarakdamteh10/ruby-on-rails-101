class AddTotalWorkedDaysToPayrolls < ActiveRecord::Migration[8.1]
  def change
    add_column :payrolls, :total_worked_days, :integer
  end
end
