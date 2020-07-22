class AuthEmailNotUnique < ActiveRecord::Migration[6.0]
  def change
    remove_index :auths, :email
    add_index :auths, :email
  end
end
