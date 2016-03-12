class AddSeoFieldsToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :seo_title,       :string
    add_column :posts, :seo_description, :string
    add_column :posts, :seo_locale,      :string
    add_column :posts, :seo_site_name,   :string
    add_column :posts, :og_type,         :string
    add_column :posts, :fb_admins,       :string
    add_column :posts, :twitter_card,    :string
    add_column :posts, :twitter_site,    :string
  end
end
