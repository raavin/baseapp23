class CreateCasenotes < ActiveRecord::Migration
  def self.up
    create_table :casenotes do |t|
      t.references :client
      t.string :note

      t.timestamps
    end
  end

  def self.down
    drop_table :casenotes
  end
end
