class CreateClips < ActiveRecord::Migration[6.1]
  def change
    create_table :clips do |t|
      t.string :clipName
      t.string :uploadUser

      t.timestamps
    end
  end
end
