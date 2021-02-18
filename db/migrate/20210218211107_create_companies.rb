class CreateCompanies < ActiveRecord::Migration[6.1]
  def change
    create_table :companies do |t|
      t.string :name
      t.text :address
      t.integer :cnpj
      t.string :site
      t.string :social_media

      t.timestamps
    end
  end
end
