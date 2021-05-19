class CreateActivitiesUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :activities_users do |t|
      t.references :activity, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.datetime :user_initial_date
      t.datetime :user_final_date
      t.datetime :user_result_date
      t.decimal :user_grade, null: true
      t.string :status
      t.integer :last_question

      t.timestamps
    end
  end
end
