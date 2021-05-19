class AddDecisionIdToClips < ActiveRecord::Migration[6.1]
  def change
    add_reference :clips, :decision, null: true, foreign_key: true
  end
end
