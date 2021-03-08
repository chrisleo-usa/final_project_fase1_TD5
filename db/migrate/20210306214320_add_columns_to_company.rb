class AddColumnsToCompany < ActiveRecord::Migration[6.1]
  def change
    add_column :companies, :city, :string
    add_column :companies, :state, :string
    add_column :companies, :complement, :string
  end
end
