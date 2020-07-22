class RemovePasswordFromAuths < ActiveRecord::Migration[6.0]
  def change
    remove_column :auths, :encrypted_password
  end
end
