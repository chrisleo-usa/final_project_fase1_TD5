class CreateJobs < ActiveRecord::Migration[6.1]
  def change
    create_table :jobs do |t|
      t.string :title
      t.text :description
      t.decimal :salary_range
      t.text :requirements
      t.date :deadline_application
      t.integer :total_vacancies

      t.timestamps
    end
  end
end
