class CreateAnswers < ActiveRecord::Migration[6.1]
  def change
    create_table :answers do |t|
      t.string :description
      t.string :option

      t.timestamps
    end
  end
end
