class CreateLookups < ActiveRecord::Migration[8.1]
  def change
    create_table :lookups do |t|
      t.string :session_id
      t.string :lookup_id
      t.string :url
      t.string :status
      t.string :title
      t.text :description
      t.string :image
      t.string :og_url
      t.string :og_type
      t.string :site_name
      t.string :error

      t.timestamps
    end

    add_index :lookups, :session_id
    add_index :lookups, [:session_id, :lookup_id], unique: true
  end
end
