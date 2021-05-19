class CreateActivities < ActiveRecord::Migration[6.1]
  def change
    create_table :activities do |t|
      t.string :name
      t.string :responsible
      t.datetime :initial_date
      t.datetime :final_date
      t.datetime :result_date
      t.decimal :grade

      t.timestamps
    end
  end
end
