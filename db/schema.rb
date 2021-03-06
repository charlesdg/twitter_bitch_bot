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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140824091027) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "campaigns", force: true do |t|
    t.integer  "users_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "follow_actions", force: true do |t|
    t.integer  "followers_id"
    t.integer  "users_id"
    t.datetime "follow_date"
    t.datetime "followback_date"
    t.integer  "state"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "followers", force: true do |t|
    t.integer  "tweets"
    t.integer  "following"
    t.integer  "followers_c"
    t.string   "username_twitter"
    t.string   "klout_id"
    t.integer  "klout_score"
    t.string   "location"
    t.string   "lang"
    t.datetime "last_tweet"
    t.integer  "influencer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "twitter_id",       limit: 8
    t.decimal  "social_authority"
  end

  add_index "followers", ["twitter_id"], name: "index_followers_on_twitter_id", unique: true, using: :btree

  create_table "identities", force: true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "identities", ["user_id"], name: "index_identities_on_user_id", using: :btree

  create_table "influencers", force: true do |t|
    t.integer  "tweets"
    t.integer  "following"
    t.integer  "followers_c"
    t.string   "username_twitter"
    t.string   "klout_id"
    t.integer  "klout_score"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "twitter_id",       limit: 8
    t.string   "location"
  end

  add_index "influencers", ["twitter_id"], name: "index_influencers_on_twitter_id", unique: true, using: :btree

  create_table "topics", force: true do |t|
    t.integer  "influencer_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
