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

ActiveRecord::Schema.define(version: 20141107224403) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "active_admin_comments", force: true do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "admin_users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

  create_table "charges", force: true do |t|
    t.string   "amount"
    t.string   "currency"
    t.integer  "customer_id"
    t.integer  "organization_id"
    t.datetime "charged_back_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "pusher_channel_token"
    t.hstore   "config"
    t.string   "status",               default: "live"
    t.boolean  "paid",                 default: false,  null: false
    t.string   "stripe_id"
    t.hstore   "card"
  end

  add_index "charges", ["customer_id"], name: "index_charges_on_customer_id", using: :btree
  add_index "charges", ["organization_id"], name: "index_charges_on_organization_id", using: :btree

  create_table "charges_tags", force: true do |t|
    t.integer "tag_id"
    t.integer "charge_id"
  end

  add_index "charges_tags", ["tag_id", "charge_id"], name: "index_charges_tags_on_tag_id_and_charge_id", using: :btree

  create_table "crms", force: true do |t|
    t.integer  "organization_id"
    t.string   "donation_page_name"
    t.string   "host"
    t.string   "username"
    t.string   "encrypted_password"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "platform"
    t.string   "default_currency",   default: "USD"
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
    t.string   "status",         default: "live"
  end

  add_index "customers", ["email", "status"], name: "index_customers_on_email_and_status", unique: true, using: :btree

  create_table "import_stubs", force: true do |t|
    t.integer  "crm_id"
    t.string   "payment_account"
    t.string   "donation_currency"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "import_stubs", ["crm_id"], name: "index_import_stubs_on_crm_id", using: :btree

  create_table "log_entries", force: true do |t|
    t.integer  "charge_id"
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "log_entries", ["charge_id"], name: "index_log_entries_on_charge_id", using: :btree

  create_table "oauth_access_grants", force: true do |t|
    t.integer  "resource_owner_id", null: false
    t.integer  "application_id",    null: false
    t.string   "token",             null: false
    t.integer  "expires_in",        null: false
    t.text     "redirect_uri",      null: false
    t.datetime "created_at",        null: false
    t.datetime "revoked_at"
    t.string   "scopes"
  end

  add_index "oauth_access_grants", ["token"], name: "index_oauth_access_grants_on_token", unique: true, using: :btree

  create_table "oauth_access_tokens", force: true do |t|
    t.integer  "resource_owner_id"
    t.integer  "application_id"
    t.string   "token",             null: false
    t.string   "refresh_token"
    t.integer  "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at",        null: false
    t.string   "scopes"
  end

  add_index "oauth_access_tokens", ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true, using: :btree
  add_index "oauth_access_tokens", ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id", using: :btree
  add_index "oauth_access_tokens", ["token"], name: "index_oauth_access_tokens_on_token", unique: true, using: :btree

  create_table "oauth_applications", force: true do |t|
    t.string   "name",         null: false
    t.string   "uid",          null: false
    t.string   "secret",       null: false
    t.text     "redirect_uri", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "oauth_applications", ["uid"], name: "index_oauth_applications_on_uid", unique: true, using: :btree

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
    t.integer  "sign_in_count",               default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.hstore   "global_defaults"
    t.string   "encrypted_password",          default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.boolean  "testmode"
    t.string   "refresh_token"
    t.boolean  "stripe_live_mode"
    t.string   "stripe_publishable_test_key"
    t.string   "stripe_test_access_token"
  end

  add_index "organizations", ["reset_password_token"], name: "index_organizations_on_reset_password_token", unique: true, using: :btree
  add_index "organizations", ["slug"], name: "index_organizations_on_slug", unique: true, using: :btree

  create_table "tag_namespaces", force: true do |t|
    t.integer  "organization_id"
    t.string   "namespace"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tag_namespaces", ["organization_id", "namespace"], name: "index_tag_namespaces_on_organization_id_and_namespace", using: :btree

  create_table "tags", force: true do |t|
    t.string   "name"
    t.integer  "organization_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "namespace_id"
  end

  add_index "tags", ["organization_id", "name"], name: "index_tags_on_organization_id_and_name", using: :btree
  add_index "tags", ["organization_id", "namespace_id"], name: "index_tags_on_organization_id_and_namespace_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
