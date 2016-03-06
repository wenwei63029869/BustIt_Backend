class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.string :display_name
      t.string :email
      t.string :phone_number
      t.string :keyword
      t.string :status
      t.references :room, index: true
      t.string :facebook
      t.string :role
    end
  end
end
