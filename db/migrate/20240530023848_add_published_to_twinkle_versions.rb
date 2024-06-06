class AddPublishedToTwinkleVersions < ActiveRecord::Migration[7.1]
  def change
    add_column :twinkle_versions, :published, :boolean, default: false, null: false
    add_index :twinkle_versions, [:twinkle_app_id, :published]
  end
end
