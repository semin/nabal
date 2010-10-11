class CreatePredictions < ActiveRecord::Migration
  def self.up
    create_table :predictions do |t|
      t.text      :sequence
      t.text      :prediction
      t.string    :uuid
      t.string    :mode
      t.datetime  :started_at
      t.datetime  :finished_at
      t.float     :elapsed_time
      t.string    :status

      t.timestamps
    end
  end

  def self.down
    drop_table :predictions
  end
end
