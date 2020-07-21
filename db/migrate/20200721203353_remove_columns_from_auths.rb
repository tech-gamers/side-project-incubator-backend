class RemoveColumnsFromAuths < ActiveRecord::Migration[6.0]
  def change
    remove_column :auths, :remember_created_at
    remove_column :auths, :locked_at
    remove_column :auths, :unlock_token
  end
end
