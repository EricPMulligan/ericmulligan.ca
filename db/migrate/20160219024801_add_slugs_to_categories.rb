class AddSlugsToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :slug, :string
    add_index :categories, :slug, unique: true
    change_column_null :categories, :slug, false, ''
  end
end
