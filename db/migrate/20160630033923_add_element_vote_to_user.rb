class AddElementVoteToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :interation, :boolean
  end
end
