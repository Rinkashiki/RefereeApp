class AddVideoToClip < ActiveRecord::Migration[6.1]
  def change
  	add_column :clips, :video, :string
  end
end
