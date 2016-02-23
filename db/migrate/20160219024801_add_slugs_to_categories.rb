class AddSlugsToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :slug, :string
    change_column_null :categories, :slug, false, ''
    add_index :categories, :slug
  end
end
