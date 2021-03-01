class CreateAccepts < ActiveRecord::Migration[6.1]
  def change
    create_table :accepts do |t|
      t.date :start_date
      t.references :proposal, null: false, foreign_key: true

      t.timestamps
    end
  end
end
