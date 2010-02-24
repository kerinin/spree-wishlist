class CreateWishedObjects < ActiveRecord::Migration
  def self.up
    create_table :wished_objects do |t|
      t.references :object, :polymorphic => true
      t.references :wishlist
      t.text :remark
      
      t.integer :position

      t.timestamps
    end
  end

  def self.down
    drop_table :wished_objects
  end
end
