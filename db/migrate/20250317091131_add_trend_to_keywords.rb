class AddTrendToKeywords < ActiveRecord::Migration[7.1]
  def change
    add_column :keywords, :trend, :decimal, precision: 5, scale: 2, default: 0
  end
end
