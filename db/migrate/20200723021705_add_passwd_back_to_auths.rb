class AddPasswdBackToAuths < ActiveRecord::Migration[6.0]
  def change
    add_column :auths, :encrypted_password, :string
  end
end
