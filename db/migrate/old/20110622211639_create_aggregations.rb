class CreateAggregations < ActiveRecord::Migration
  def self.up
    create_table :aggregations do |t|
      t.string :name
      t.float :value
      t.integer :contribs
      t.string :thecontroller
      t.integer :theid
      t.string :group
      t.text :man_link

      t.timestamps
    end
  end

  def self.down
    drop_table :aggregations
  end
end
