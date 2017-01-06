class CreatePostColumns < ActiveRecord::Migration[5.0]
  def change
    add_column :posts, :artist, :string
    add_column :posts, :location, :string
  end
  
end
