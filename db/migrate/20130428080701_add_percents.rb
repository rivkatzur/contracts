class AddPercents < ActiveRecord::Migration
  def change
    add_column :contracts, :percents, :integer, :default => 10
  end
end
