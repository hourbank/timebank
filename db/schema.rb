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

ActiveRecord::Schema.define(version: 20150512211358) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "exchanges", force: :cascade do |t|
    t.integer  "provided_by_id"
    t.integer  "received_by_id"
    t.decimal  "estimated_hours"
    t.decimal  "final_hours"
    t.text     "description"
    t.boolean  "proposed"
    t.datetime "proposed_date"
    t.boolean  "accepted"
    t.datetime "accepted_date"
    t.boolean  "delivered"
    t.datetime "delivered_date"
    t.boolean  "confirmed"
    t.datetime "confirmed_date"
    t.integer  "service_requested_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.string   "title"
    t.text     "location"
  end

  create_table "service_requests", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.decimal  "estimated_hours"
    t.text     "location"
    t.text     "timing"
    t.integer  "requested_by_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "first_name",                                      null: false
    t.string   "last_name",                                       null: false
    t.string   "phone",                  limit: 10,               null: false
    t.text     "services_offered"
    t.string   "city"
    t.integer  "zipcode",                limit: 8
    t.decimal  "time_balance",                      default: 0.0
    t.string   "email",                             default: "",  null: false
    t.string   "encrypted_password",                default: "",  null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                     default: 0,   null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
