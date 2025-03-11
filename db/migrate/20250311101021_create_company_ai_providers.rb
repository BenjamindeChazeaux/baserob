class CreateCompanyAiProviders < ActiveRecord::Migration[7.1]
  def change
    create_table :company_ai_providers do |t|
      t.references :company, null: false, foreign_key: true
      t.references :ai_provider, null: false, foreign_key: true

      t.timestamps
    end
  end
end
