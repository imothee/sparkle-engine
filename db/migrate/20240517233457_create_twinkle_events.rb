class CreateTwinkleEvents < ActiveRecord::Migration[7.1]
  def change
    create_table :twinkle_events do |t|
      t.references :twinkle_app, null: false, foreign_key: true
      t.string :version
      t.boolean :cpu64bit
      t.integer :ncpu
      t.string :cpu_freq_mhz
      t.string :cputype
      t.string :cpusubtype
      t.string :model
      t.string :ram_mb
      t.string :os_version
      t.string :lang

      t.timestamps
    end
  end
end
