class CreateRequests < ActiveRecord::Migration[7.1]
  def change
    create_table :requests do |t|
      t.string :domain
      t.string :path
      t.string :referrer
      t.string :user_agent
      t.references :company, null: false, foreign_key: true
      t.references :ai_provider, null: false, foreign_key: true

      t.timestamps
    end
  end
end
