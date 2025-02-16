class AddWinnerCalculationMethodToBudgets < ActiveRecord::Migration[7.0]
  def change
    add_column :budgets, :winner_calculation_method, :string, default: "highest_votes"
  end
end
