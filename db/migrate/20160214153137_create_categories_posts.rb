class CreateCategoriesPosts < ActiveRecord::Migration
  def change
    create_table :categories_posts do |t|
      t.references :category, null: false
      t.references :post,     null: false

      t.index :category_id
      t.index :post_id
    end
  end
end
