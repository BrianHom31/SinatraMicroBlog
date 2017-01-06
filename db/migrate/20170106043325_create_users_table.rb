class CreateUsersTable < ActiveRecord::Migration[5.0]
  def change
    create_table 'users' do |t|
      t.string :username
      t.string :password
      t.string :email
    end

    create_table 'posts' do |t|
      t.integer :user_id
      t.string :title
      t.text :content
    end

  end
end
