class CreateIsocodes < ActiveRecord::Migration
  def self.up
    create_table :isocodes do |t|
	t.string :country
	t.string :longitude
	t.string :latitude
      t.timestamps
    end
  end

  def self.down
    drop_table :isocodes
  end
end
