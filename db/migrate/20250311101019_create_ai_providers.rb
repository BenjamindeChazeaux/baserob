class CreateAiProviders < ActiveRecord::Migration[7.1]
  def change
    create_table :ai_providers do |t|
      t.string :name

      t.timestamps
    end
  end
end
