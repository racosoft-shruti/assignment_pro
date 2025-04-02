class AddColumnUserIdInCatalogue < ActiveRecord::Migration[8.0]
  def change
    add_column :catalogues, :user_id, :bigint
  end
end
