class CreateUserColumns < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :fname, :string
    add_column :users, :lname, :string
    add_column :users, :user_location, :string
    add_column :users, :fav_genre, :string
    add_column :users, :fav_artist1, :string
    add_column :users, :fav_artist2, :string
    add_column :users, :fav_artist3, :string
  end
end
