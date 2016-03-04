class CreateAuthorizations < ActiveRecord::Migration
  def change
    create_table "authorizations", force: :cascade do |t|
      t.string "provider"
      t.string "uid"
      t.string "token"
      t.integer "player_id"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string "secret"
    end
  end
end
