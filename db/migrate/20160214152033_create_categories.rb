class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.timestamps              null: false
      t.references :created_by, null: false
      t.string :name,           null: false
      t.text :description,      null: false, default: ''

      t.index :created_by_id
      t.index :name
    end
  end
end
