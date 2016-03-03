class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.string :name
      t.string :phone_number
      t.string :keyword
      t.string :status
      t.references :room, index: true
    end
  end
end
