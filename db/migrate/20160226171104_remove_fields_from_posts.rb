class RemoveFieldsFromPosts < ActiveRecord::Migration
  def change
    remove_column :posts, :fb_admins, :string
    remove_column :posts, :seo_site_name, :string
    remove_column :posts, :seo_locale, :string
    remove_column :posts, :twitter_card, :string
    rename_column :posts, :og_type, :seo_type
  end
end
