class CreateResources < ActiveRecord::Migration[7.1]
  def change
    create_table :resources do |t|
      t.string :title
      t.string :slug
      t.text :content
      t.text :summary
      t.boolean :featured
      t.datetime :published_at
      t.string :category
      t.string :author
      t.string :cover_image
      t.integer :reading_time

      t.timestamps
    end
  end
end
