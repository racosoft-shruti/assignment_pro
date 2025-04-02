class AddColumnHiddenDaysToCatalogue < ActiveRecord::Migration[8.0]
  def change
    add_column :catalogues, :hide_days, :datetime
  end
end
