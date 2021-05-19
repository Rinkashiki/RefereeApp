class AddClipIdToQuestions < ActiveRecord::Migration[6.1]
  def change
    add_reference :questions, :clip, null: true, foreign_key: true
  end
end
