# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160226171104) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "created_by_id",              null: false
    t.string   "name",                       null: false
    t.text     "description",   default: "", null: false
    t.string   "slug",                       null: false
    t.index ["created_by_id"], name: "index_categories_on_created_by_id", using: :btree
    t.index ["name"], name: "index_categories_on_name", using: :btree
    t.index ["slug"], name: "index_categories_on_slug", using: :btree
  end

  create_table "categories_posts", force: :cascade do |t|
    t.integer "category_id", null: false
    t.integer "post_id",     null: false
    t.index ["category_id"], name: "index_categories_posts_on_category_id", using: :btree
    t.index ["post_id"], name: "index_categories_posts_on_post_id", using: :btree
  end

  create_table "contacts", force: :cascade do |t|
    t.integer  "read_by_id"
    t.string   "name",       default: ""
    t.string   "email",                   null: false
    t.text     "body",                    null: false
    t.datetime "read_at"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.index ["created_at"], name: "index_contacts_on_created_at", using: :btree
    t.index ["email"], name: "index_contacts_on_email", using: :btree
    t.index ["read_at"], name: "index_contacts_on_read_at", using: :btree
    t.index ["read_by_id"], name: "index_contacts_on_read_by_id", using: :btree
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree
  end

  create_table "posts", force: :cascade do |t|
    t.integer  "created_by_id",                   null: false
    t.string   "title",                           null: false
    t.text     "body",            default: "",    null: false
    t.boolean  "published",       default: false, null: false
    t.datetime "published_at"
    t.string   "slug",                            null: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "seo_title"
    t.string   "seo_description"
    t.index ["created_at"], name: "index_posts_on_created_at", using: :btree
    t.index ["created_by_id"], name: "index_posts_on_created_by_id", using: :btree
    t.index ["published"], name: "index_posts_on_published", using: :btree
    t.index ["slug"], name: "index_posts_on_slug", unique: true, using: :btree
    t.index ["title"], name: "index_posts_on_title", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.string   "email",                                       null: false
    t.string   "encrypted_password", limit: 128,              null: false
    t.string   "confirmation_token", limit: 128
    t.string   "remember_token",     limit: 128,              null: false
    t.string   "name",                           default: "", null: false
    t.index ["email"], name: "index_users_on_email", using: :btree
    t.index ["remember_token"], name: "index_users_on_remember_token", using: :btree
  end

  add_foreign_key "categories", "users", column: "created_by_id"
  add_foreign_key "categories_posts", "categories"
  add_foreign_key "categories_posts", "posts"
  add_foreign_key "posts", "users", column: "created_by_id"
end
