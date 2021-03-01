class CreateDeclines < ActiveRecord::Migration[6.1]
  def change
    create_table :declines do |t|
      t.text :reason
      t.references :proposal, null: false, foreign_key: true

      t.timestamps
    end
  end
end
