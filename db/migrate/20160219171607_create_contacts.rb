class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.references :read_by

      t.string :name, default: ''
      t.string :email, null: false
      t.text :body, null: false
      t.datetime :read_at

      t.timestamps null: false

      t.index :read_by_id
      t.index :email
      t.index :read_at
      t.index :created_at
    end
  end
end
