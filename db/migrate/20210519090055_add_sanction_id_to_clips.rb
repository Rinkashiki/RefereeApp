class AddSanctionIdToClips < ActiveRecord::Migration[6.1]
  def change
    add_reference :clips, :sanction, null: true, foreign_key: true
  end
end
