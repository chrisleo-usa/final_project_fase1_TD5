class AddAdminToEmployee < ActiveRecord::Migration[6.1]
  def change
    add_column :employees, :admin, :integer, default: 0, null: false
  end
end
