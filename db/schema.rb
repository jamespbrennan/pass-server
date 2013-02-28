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

ActiveRecord::Schema.define(version: 20130228220112) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "authentications", force: true do |t|
    t.string   "ip_address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "prover_id"
    t.integer  "service_id"
  end

  create_table "device_types", force: true do |t|
    t.string   "name"
    t.string   "identifier"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "manufacturer"
    t.string   "model"
  end

  create_table "provers", force: true do |t|
    t.string   "public_key"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "device_type_id"
    t.string   "name"
    t.integer  "user_id"
  end

  create_table "services", force: true do |t|
    t.string   "name"
    t.string   "access_token"
    t.string   "allowed_ip_addresses"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "sessions", force: true do |t|
    t.string   "ip_address"
    t.string   "user_agent"
    t.string   "token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "service_id"
    t.integer  "prover_id"
  end

  create_table "users", force: true do |t|
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
