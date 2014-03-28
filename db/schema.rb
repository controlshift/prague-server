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

ActiveRecord::Schema.define(version: 20140328204931) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "charges", force: true do |t|
    t.string   "amount"
    t.string   "currency"
    t.integer  "customer_id"
    t.integer  "organization_id"
    t.datetime "charged_back_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "pusher_channel_token"
  end

  add_index "charges", ["customer_id"], name: "index_charges_on_customer_id", using: :btree
  add_index "charges", ["organization_id"], name: "index_charges_on_organization_id", using: :btree

  create_table "crms", force: true do |t|
    t.integer  "organization_id"
    t.string   "donation_page_name"
    t.string   "host"
    t.string   "username"
    t.string   "encrypted_password"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "crms", ["organization_id"], name: "index_crms_on_organization_id", using: :btree

  create_table "customers", force: true do |t|
    t.string   "customer_token"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "country"
    t.string   "zip"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "organizations", force: true do |t|
    t.string   "access_token"
    t.string   "stripe_publishable_key"
    t.string   "stripe_user_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email"
    t.string   "slug"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
  end

end
