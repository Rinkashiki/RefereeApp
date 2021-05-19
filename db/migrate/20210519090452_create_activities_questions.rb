class CreateActivitiesQuestions < ActiveRecord::Migration[6.1]
  def change
    create_table :activities_questions do |t|
      t.references :activity, null: false, foreign_key: true
      t.references :question, null: false, foreign_key: true

      t.timestamps
    end
  end
end
