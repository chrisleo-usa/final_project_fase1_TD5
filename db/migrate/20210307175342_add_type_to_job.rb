class AddTypeToJob < ActiveRecord::Migration[6.1]
  def change
    add_column :jobs, :type_hiring, :integer
  end
end
