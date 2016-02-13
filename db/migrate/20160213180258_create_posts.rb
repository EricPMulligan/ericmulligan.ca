class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.references :created_by, null: false
      t.string :title,          null: false
      t.text :body,             null: false, default: ''
      t.boolean :published,     null: false, default: false
      t.datetime :published_at
      t.string :slug,           null: false
      t.timestamps              null: false

      t.index :title
      t.index :created_at, order: :desc
      t.index :published
      t.index :slug, unique: true
      t.index :created_by_id
    end
  end
end
