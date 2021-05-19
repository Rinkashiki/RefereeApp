class CreateActivityUserAnswers < ActiveRecord::Migration[6.1]
  def change
    create_table :activity_user_answers do |t|
    	  t.references :activities_users, null: false, foreign_key: true
        t.json :answers, null: true
        #t.string :answers, null: true
        #serialize :answers, JSON # If you use SQLite, add this line.s
        t.references :decision, null: true, foreign_key: true
        t.references :sanction, null: true, foreign_key: true
        t.text :open_question, null: true

      	t.timestamps
    end
  end
end
