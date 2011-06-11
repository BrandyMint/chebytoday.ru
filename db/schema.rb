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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110611062413) do

  create_table "articles", :force => true do |t|
    t.boolean  "is_mained",    :default => false, :null => false
    t.datetime "published_at",                    :null => false
    t.string   "title",                           :null => false
    t.string   "author",                          :null => false
    t.string   "guid",                            :null => false
    t.integer  "blog_id",                         :null => false
    t.string   "link"
    t.text     "summary",                         :null => false
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "articles", ["guid"], :name => "index_articles_on_guid", :unique => true
  add_index "articles", ["is_mained"], :name => "index_articles_on_is_mained"
  add_index "articles", ["published_at"], :name => "index_articles_on_published_at"

  create_table "blogs", :force => true do |t|
    t.string   "author"
    t.string   "title"
    t.string   "link"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "yandex_rating",       :limit => 8
    t.integer  "friends"
    t.string   "rss_link"
    t.integer  "articles_count"
    t.datetime "articles_updated_at"
    t.integer  "user_id"
  end

  add_index "blogs", ["friends"], :name => "index_blog_sources_on_friends"
  add_index "blogs", ["yandex_rating"], :name => "index_blog_sources_on_yandex_rating"

  create_table "histories", :force => true do |t|
    t.string   "message"
    t.string   "username"
    t.integer  "item"
    t.string   "table"
    t.integer  "month",      :limit => 2
    t.integer  "year",       :limit => 8
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "histories", ["item", "table", "month", "year"], :name => "index_histories_on_item_and_table_and_month_and_year"

  create_table "politics", :force => true do |t|
    t.string   "name"
    t.string   "title"
    t.text     "desc"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "purchases", :force => true do |t|
    t.string   "title"
    t.string   "image"
    t.string   "link"
    t.date     "end_date"
    t.integer  "user_id"
    t.text     "description"
    t.string   "kind"
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id",   :limit => 8
    t.string   "taggable_type"
    t.integer  "tagger_id",     :limit => 8
    t.string   "tagger_type"
    t.string   "context"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "twit_users", :id => false, :force => true do |t|
    t.integer  "id",                :limit => 8
    t.string   "screen_name"
    t.string   "profile_image_url"
    t.integer  "friends_count",                                     :null => false
    t.integer  "statuses_count",                                    :null => false
    t.boolean  "following"
    t.boolean  "is_cheboksary"
    t.string   "state",                                             :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "favourites_count"
    t.integer  "followers_count"
    t.datetime "twiter_created_at"
    t.integer  "listed_count"
    t.string   "name"
    t.boolean  "is_anounced",                    :default => false
    t.datetime "followed_at"
    t.string   "location"
    t.string   "source"
    t.string   "cheboksary_source"
  end

  add_index "twit_users", ["is_cheboksary"], :name => "index_twit_users_on_is_cheboksary"
  add_index "twit_users", ["screen_name"], :name => "index_twit_users_on_screen_name", :unique => true
  add_index "twit_users", ["state", "is_cheboksary"], :name => "index_twit_users_on_state_and_is_cheboksary"
  add_index "twit_users", ["state"], :name => "index_twit_users_on_state"

  create_table "twits", :id => false, :force => true do |t|
    t.integer  "id",                      :limit => 8
    t.text     "text"
    t.datetime "created_at"
    t.boolean  "favorited"
    t.text     "place"
    t.text     "retweeted_status"
    t.string   "geo"
    t.boolean  "truncated"
    t.string   "source"
    t.string   "contributors"
    t.string   "coordinated"
    t.integer  "twitter_id",              :limit => 8
    t.integer  "in_reply_to_user_id",     :limit => 8
    t.integer  "in_reply_to_status_id",   :limit => 8
    t.string   "in_reply_to_screen_name"
    t.datetime "updated_at"
  end

  add_index "twits", ["id"], :name => "index_twits_on_id", :unique => true

  create_table "twitters", :id => false, :force => true do |t|
    t.integer  "id",                 :limit => 8
    t.string   "screen_name",                                    :null => false
    t.string   "name"
    t.string   "profile_image_url"
    t.integer  "friends_count",                   :default => 0, :null => false
    t.integer  "statuses_count",                  :default => 0, :null => false
    t.integer  "favourites_count",                :default => 0, :null => false
    t.integer  "listed_count",                    :default => 0, :null => false
    t.string   "location"
    t.string   "source",                                         :null => false
    t.string   "state",                                          :null => false
    t.string   "list_state",                                     :null => false
    t.datetime "twitter_created_at",                             :null => false
    t.datetime "anounced_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "followers_count",                 :default => 0, :null => false
  end

  add_index "twitters", ["favourites_count"], :name => "index_twitters_on_favourites_count"
  add_index "twitters", ["followers_count"], :name => "index_twitters_on_followers_count"
  add_index "twitters", ["friends_count"], :name => "index_twitters_on_friends_count"
  add_index "twitters", ["id"], :name => "index_twitters_on_id", :unique => true
  add_index "twitters", ["listed_count"], :name => "index_twitters_on_listed_count"
  add_index "twitters", ["screen_name"], :name => "index_twitters_on_screen_name", :unique => true
  add_index "twitters", ["source"], :name => "index_twitters_on_source"
  add_index "twitters", ["state"], :name => "index_twitters_on_state"
  add_index "twitters", ["statuses_count"], :name => "index_twitters_on_statuses_count"
  add_index "twitters", ["twitter_created_at"], :name => "index_twitters_on_twitter_created_at"

  create_table "users", :force => true do |t|
    t.string   "email",                               :default => "",   :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "",   :null => false
    t.string   "reset_password_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "nick",                                                  :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "role"
    t.boolean  "status",                              :default => true, :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["nick"], :name => "index_users_on_nick", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
