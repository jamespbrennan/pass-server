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

ActiveRecord::Schema.define(version: 20130411021125) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "api_tokens", force: true do |t|
    t.string   "token",             limit: 32
    t.integer  "api_consumer_id"
    t.string   "api_consumer_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "api_tokens", ["api_consumer_id", "api_consumer_type"], name: "index_api_tokens_on_api_consumer_id_and_api_consumer_type"
  add_index "api_tokens", ["token"], name: "index_api_tokens_on_token"

  create_table "callback_types", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "callbacks", force: true do |t|
    t.string   "address"
    t.integer  "callback_type_id"
    t.integer  "service_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "device_accounts", force: true do |t|
    t.text     "public_key"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "device_id"
    t.integer  "service_id"
  end

  add_index "device_accounts", ["device_id"], name: "index_device_accounts_on_device_id"
  add_index "device_accounts", ["service_id"], name: "index_device_accounts_on_service_id"

  create_table "device_types", force: true do |t|
    t.string   "name"
    t.string   "identifier"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "manufacturer"
    t.string   "model"
  end

  create_table "devices", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "device_type_id"
    t.string   "name"
    t.integer  "user_id"
  end

  add_index "devices", ["user_id"], name: "index_devices_on_user_id"

  create_table "services", force: true do |t|
    t.string   "name"
    t.string   "allowed_ip_addresses", array: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "url"
  end

  create_table "sessions", force: true do |t|
    t.string   "user_agent"
    t.string   "token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_authenticated"
    t.integer  "device_id"
    t.integer  "service_id"
    t.inet     "remote_ip_address"
    t.inet     "device_ip_address"
  end

  add_index "sessions", ["device_id"], name: "index_sessions_on_device_id"
  add_index "sessions", ["service_id"], name: "index_sessions_on_service_id"

  create_table "users", force: true do |t|
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
  end

end
