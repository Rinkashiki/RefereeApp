class CreateClipsTopics < ActiveRecord::Migration[6.1]
  def change
    create_table :clips_topics do |t|
      t.references :clip, null: false, foreign_key: true
      t.references :topic, null: false, foreign_key: true

      t.timestamps
    end
  end
end
