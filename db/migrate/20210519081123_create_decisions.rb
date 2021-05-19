class CreateDecisions < ActiveRecord::Migration[6.1]
  def change
    create_table :decisions do |t|
      t.string :description
      t.string :initials

      t.timestamps
    end
  end
end
