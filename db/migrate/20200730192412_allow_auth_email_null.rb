class AllowAuthEmailNull < ActiveRecord::Migration[6.0]
  def change
    change_column_null :auths, :email, true
  end
end
