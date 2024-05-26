class CreateTwinkleApps < ActiveRecord::Migration[7.1]
  def change
    create_table :twinkle_apps do |t|
      t.string :name
      t.string :slug
      t.string :description

      t.timestamps
    end
    add_index :twinkle_apps, :slug, unique: true
  end
end
