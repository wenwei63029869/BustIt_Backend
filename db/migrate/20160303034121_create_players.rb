class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.string :name
      t.string :number
      t.string :keyword
      t.string :status
      t.integer :room_id
    end
  end
end
