class AddForeignKeys < ActiveRecord::Migration
  def change
    add_foreign_key :categories,       :users,      column: :created_by_id
    add_foreign_key :posts,            :users,      column: :created_by_id
    add_foreign_key :categories_posts, :categories, column: :category_id
    add_foreign_key :categories_posts, :posts,      column: :post_id
  end
end
