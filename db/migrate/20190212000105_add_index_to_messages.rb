class AddIndexToMessages < ActiveRecord::Migration[5.0]
  def change
    add_index :messages, [:created_at, :updated_at]
  end
end
