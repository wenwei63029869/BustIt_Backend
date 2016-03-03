class CreateKeywords < ActiveRecord::Migration
  def change
    create_table :keywords do |t|
      t.string :keyword_one
      t.string :keyword_two
    end
  end
end
