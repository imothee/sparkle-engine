class AddFieldsToTwinkleVersions < ActiveRecord::Migration[7.1]
  def change
    add_column :twinkle_versions, :sparkle_two, :boolean, default: true
    add_column :twinkle_versions, :link, :string
    add_column :twinkle_versions, :min_system_version, :string
    add_column :twinkle_versions, :max_system_version, :string
    add_column :twinkle_versions, :minimum_auto_update_version, :string
    add_column :twinkle_versions, :ignore_skipped_upgrades_below_version, :string
    add_column :twinkle_versions, :informational_update_below_version, :string
    add_column :twinkle_versions, :critical, :boolean, default: false
    add_column :twinkle_versions, :critical_version, :string
    add_column :twinkle_versions, :phased_rollout_interval, :integer
    add_column :twinkle_versions, :channel, :string
    add_column :twinkle_versions, :release_notes_link, :string
    add_column :twinkle_versions, :full_release_notes_link, :string
    add_column :twinkle_versions, :published_at, :datetime
    change_column :twinkle_versions, :build, :integer, using: 'build::integer'
  end
end
