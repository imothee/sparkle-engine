class CreateTwinkleDatapoints < ActiveRecord::Migration[7.1]
  def change
    create_table :twinkle_datapoints do |t|
      t.references :twinkle_summary, null: false, foreign_key: true
      t.string :name
      t.string :value
      t.integer :count

      t.timestamps
    end
    add_index :twinkle_datapoints, [:twinkle_summary_id, :name, :value], unique: true
  end
end
