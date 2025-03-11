class CreateCompetitors < ActiveRecord::Migration[7.1]
  def change
    create_table :competitors do |t|
      t.string :name
      t.string :domain
      t.references :company, null: false, foreign_key: true

      t.timestamps
    end
  end
end
