class AddProfileIdToUsers < ActiveRecord::Migration[6.1]
  def change
    add_reference :users, :profile, null: false, foreign_key: true
  end
end
