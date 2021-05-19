class CreateQuestions < ActiveRecord::Migration[6.1]
  def change
    create_table :questions do |t|
      t.string :question
      t.string :question_type
      t.decimal :response_time

      t.timestamps
    end
  end
end
