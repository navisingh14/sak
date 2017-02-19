class CreateUserAuths < ActiveRecord::Migration
  def change
    create_table :user_auths do |t|
      t.string :provider
      t.string :uid
      t.integer :user_id
      t.string :token

      t.timestamps
    end
  end
end
