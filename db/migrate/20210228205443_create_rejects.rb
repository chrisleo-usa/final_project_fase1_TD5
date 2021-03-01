class CreateRejects < ActiveRecord::Migration[6.1]
  def change
    create_table :rejects do |t|
      t.text :message
      t.references :enrollment, null: false, foreign_key: true

      t.timestamps
    end
  end
end
