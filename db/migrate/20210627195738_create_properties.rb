class CreateProperties < ActiveRecord::Migration[6.1]
  def change
    create_table :properties do |t|
      t.references :user, null: false, foreign_key: true
      t.string :street_adderss
      t.integer :estimated_value
      t.integer :after_repair_value
      t.integer :estimated_rent

      t.timestamps
    end
  end
end
