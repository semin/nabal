class CreateQuerySequences < ActiveRecord::Migration
  def self.up
    create_table :query_sequences do |t|
      t.string :code
      t.text :description
      t.text :sequence

      t.timestamps
    end
  end

  def self.down
    drop_table :query_sequences
  end
end
