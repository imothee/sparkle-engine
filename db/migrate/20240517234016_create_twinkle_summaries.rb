class CreateTwinkleSummaries < ActiveRecord::Migration[7.1]
  def change
    create_table :twinkle_summaries do |t|
      t.references :twinkle_app, null: false, foreign_key: true
      t.integer :period
      t.datetime :start_date
      t.datetime :end_date

      t.timestamps
    end
    add_index :twinkle_summaries, [:period, :start_date, :end_date], unique: true
  end
end
