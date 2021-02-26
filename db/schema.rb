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

ActiveRecord::Schema.define(version: 20210226220150) do

  create_table "external_payment_sources", force: :cascade do |t|
    t.integer  "user_id",     null: false
    t.string   "source_type", null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "external_payment_sources", ["user_id"], name: "index_external_payment_sources_on_user_id"

  create_table "friendships", force: :cascade do |t|
    t.integer "user_id",   null: false
    t.integer "friend_id", null: false
  end

  add_index "friendships", ["friend_id"], name: "index_friendships_on_friend_id"
  add_index "friendships", ["user_id"], name: "index_friendships_on_user_id"

  create_table "payment_accounts", force: :cascade do |t|
    t.integer  "user_id",                  null: false
    t.float    "balance",    default: 0.0, null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "payment_accounts", ["user_id"], name: "index_payment_accounts_on_user_id"

  create_table "payments", force: :cascade do |t|
    t.integer  "sender_id",   null: false
    t.integer  "friend_id",   null: false
    t.float    "amount",      null: false
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "payments", ["friend_id"], name: "index_payments_on_friend_id"
  add_index "payments", ["sender_id"], name: "index_payments_on_sender_id"

  create_table "users", force: :cascade do |t|
    t.string   "username",   null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
