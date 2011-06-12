class CreateSectors < ActiveRecord::Migration
  def self.up
    create_table :sectors do |t|
      t.string :text
      t.string :vocab
      t.string :code

      t.timestamps
    end
  end

  def self.down
    drop_table :sectors
  end
end
