class CreateCompanies < ActiveRecord::Migration[7.1]
  def change
    create_table :companies do |t|
      t.string :name
      t.string :domain
      t.string :token
      t.timestamps
    end
  end
end
