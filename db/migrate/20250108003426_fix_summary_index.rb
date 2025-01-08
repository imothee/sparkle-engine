class FixSummaryIndex < ActiveRecord::Migration[8.0]
  def change
    remove_index :twinkle_summaries, [:period, :start_date, :end_date], unique: true
    add_index :twinkle_summaries, [:twinkle_app_id, :period, :start_date, :end_date], unique: true
  end
end
