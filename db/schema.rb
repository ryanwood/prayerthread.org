# encoding: UTF-8
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

ActiveRecord::Schema.define(:version => 20150611181936) do

  create_table "activities", :force => true do |t|
    t.integer  "user_id"
    t.integer  "prayer_id"
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type"
  end

  create_table "announcements", :force => true do |t|
    t.text     "message"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", :force => true do |t|
    t.integer  "prayer_id"
    t.integer  "user_id"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "groups", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "owner_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "cached_slug"
  end

  create_table "groups_prayers", :id => false, :force => true do |t|
    t.integer "group_id"
    t.integer "prayer_id"
  end

  add_index "groups_prayers", ["group_id", "prayer_id"], :name => "index_groups_prayers_on_group_id_and_prayer_id", :unique => true

  create_table "invitations", :force => true do |t|
    t.integer  "group_id"
    t.integer  "sender_id"
    t.string   "recipient_email"
    t.string   "token"
    t.datetime "sent_at"
    t.datetime "accepted_at"
    t.integer  "recipient_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "ignored",         :default => false
  end

  create_table "memberships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "notification_level"
    t.boolean  "notify_on_prayer_created",          :default => false, :null => false
    t.boolean  "notify_on_prayer_answered",         :default => false, :null => false
    t.boolean  "notify_on_comment_from_originator", :default => false, :null => false
    t.boolean  "notify_on_comment_to_originator",   :default => false, :null => false
  end

  add_index "memberships", ["user_id", "group_id"], :name => "index_memberships_on_user_id_and_group_id", :unique => true

  create_table "notifications", :force => true do |t|
    t.integer "source_id"
    t.string  "source_type"
    t.string  "event_type"
    t.boolean "sent",        :default => false, :null => false
  end

  create_table "prayers", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.integer  "user_id"
    t.boolean  "private",           :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "thread_updated_at"
    t.string   "cached_slug"
    t.datetime "answered_at"
    t.text     "answer"
    t.integer  "comments_count",    :default => 0
    t.boolean  "praise",            :default => false
  end

  create_table "slugs", :force => true do |t|
    t.string   "name"
    t.integer  "sluggable_id"
    t.integer  "sequence",                     :default => 1, :null => false
    t.string   "sluggable_type", :limit => 40
    t.string   "scope",          :limit => 40
    t.datetime "created_at"
  end

  add_index "slugs", ["name", "sluggable_type", "scope", "sequence"], :name => "index_slugs_on_n_s_s_and_s", :unique => true
  add_index "slugs", ["sluggable_id"], :name => "index_slugs_on_sluggable_id"

  create_table "users", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "encrypted_password", :limit => 128
    t.string   "salt",               :limit => 128
    t.string   "confirmation_token", :limit => 128
    t.string   "remember_token",     :limit => 128
    t.boolean  "email_confirmed",                   :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "send_reminder"
    t.boolean  "send_announcements"
  end

  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["id", "confirmation_token"], :name => "index_users_on_id_and_confirmation_token"
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

end
