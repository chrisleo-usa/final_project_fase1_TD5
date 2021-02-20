class AddLevelToJobs < ActiveRecord::Migration[6.1]
  def change
    add_column :jobs, :level, :integer
  end
end
