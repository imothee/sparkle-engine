class CreateTwinkleVersions < ActiveRecord::Migration[7.1]
  def change
    create_table :twinkle_versions do |t|
      t.references :twinkle_app, null: false, foreign_key: true
      t.string :number
      t.string :build
      t.string :description
      t.string :binary_url
      t.string :dsa_signature
      t.string :ed_signature
      t.string :length

      t.timestamps
    end
    add_index :twinkle_versions, :build
  end
end
