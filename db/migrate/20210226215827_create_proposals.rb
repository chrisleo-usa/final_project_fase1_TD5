class CreateProposals < ActiveRecord::Migration[6.1]
  def change
    create_table :proposals do |t|
      t.references :enrollment, null: false, foreign_key: true
      t.text :proposal_message
      t.decimal :proposal_salary
      t.date :start_date
      t.integer :status, default: 0, null: false

      t.timestamps
    end
  end
end
