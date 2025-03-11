class CreateKeywords < ActiveRecord::Migration[7.1]
  def change
    create_table :keywords do |t|
      t.string :content
      t.references :company, null: false, foreign_key: true

      t.timestamps
    end
  end
end
