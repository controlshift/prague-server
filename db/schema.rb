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

ActiveRecord::Schema.define(version: 20171003182447) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "active_admin_comments", id: :serial, force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_id", null: false
    t.string "resource_type", null: false
    t.string "author_type"
    t.integer "author_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "blazer_audits", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "query_id"
    t.text "statement"
    t.datetime "created_at"
    t.string "data_source"
  end

  create_table "blazer_checks", id: :serial, force: :cascade do |t|
    t.integer "query_id"
    t.string "state"
    t.text "emails"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "blazer_dashboard_queries", id: :serial, force: :cascade do |t|
    t.integer "dashboard_id"
    t.integer "query_id"
    t.integer "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "blazer_dashboards", id: :serial, force: :cascade do |t|
    t.text "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "blazer_queries", id: :serial, force: :cascade do |t|
    t.integer "creator_id"
    t.string "name"
    t.text "description"
    t.text "statement"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "data_source"
  end

  create_table "charges", id: :serial, force: :cascade do |t|
    t.integer "amount"
    t.string "currency"
    t.integer "customer_id"
    t.integer "organization_id"
    t.datetime "charged_back_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "pusher_channel_token"
    t.hstore "config"
    t.string "status", default: "live"
    t.boolean "paid", default: false, null: false
    t.string "stripe_id"
    t.hstore "card"
    t.string "external_id"
    t.boolean "external_new_member"
    t.index ["customer_id"], name: "index_charges_on_customer_id"
    t.index ["organization_id"], name: "index_charges_on_organization_id"
  end

  create_table "charges_tags", id: :serial, force: :cascade do |t|
    t.integer "tag_id"
    t.integer "charge_id"
    t.index ["tag_id", "charge_id"], name: "index_charges_tags_on_tag_id_and_charge_id"
  end

  create_table "crms", id: :serial, force: :cascade do |t|
    t.integer "organization_id"
    t.string "donation_page_name"
    t.string "host"
    t.string "username"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "platform"
    t.string "default_currency", default: "USD"
    t.string "encrypted_password"
    t.string "encrypted_password_iv"
    t.index ["organization_id"], name: "index_crms_on_organization_id"
  end

  create_table "customers", id: :serial, force: :cascade do |t|
    t.string "customer_token"
    t.string "first_name"
    t.string "last_name"
    t.string "country"
    t.string "zip"
    t.string "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "status", default: "live"
    t.index ["email", "status"], name: "index_customers_on_email_and_status", unique: true
  end

  create_table "import_stubs", id: :serial, force: :cascade do |t|
    t.integer "crm_id"
    t.string "payment_account"
    t.string "donation_currency"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["crm_id"], name: "index_import_stubs_on_crm_id"
  end

  create_table "invitations", id: :serial, force: :cascade do |t|
    t.integer "sender_id", null: false
    t.integer "recipient_id"
    t.string "recipient_email", null: false
    t.integer "organization_id", null: false
    t.string "token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "invitation_accepted_at"
    t.index ["organization_id"], name: "index_invitations_on_organization_id"
    t.index ["sender_id"], name: "index_invitations_on_sender_id"
    t.index ["token"], name: "index_invitations_on_token", unique: true
  end

  create_table "log_entries", id: :serial, force: :cascade do |t|
    t.integer "charge_id"
    t.text "message"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["charge_id"], name: "index_log_entries_on_charge_id"
  end

  create_table "oauth_access_grants", id: :serial, force: :cascade do |t|
    t.integer "resource_owner_id", null: false
    t.integer "application_id", null: false
    t.string "token", null: false
    t.integer "expires_in", null: false
    t.text "redirect_uri", null: false
    t.datetime "created_at", null: false
    t.datetime "revoked_at"
    t.string "scopes"
    t.index ["token"], name: "index_oauth_access_grants_on_token", unique: true
  end

  create_table "oauth_access_tokens", id: :serial, force: :cascade do |t|
    t.integer "resource_owner_id"
    t.integer "application_id"
    t.string "token", null: false
    t.string "refresh_token"
    t.integer "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at", null: false
    t.string "scopes"
    t.index ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true
    t.index ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id"
    t.index ["token"], name: "index_oauth_access_tokens_on_token", unique: true
  end

  create_table "oauth_applications", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.string "uid", null: false
    t.string "secret", null: false
    t.text "redirect_uri", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "scopes", default: "", null: false
    t.index ["uid"], name: "index_oauth_applications_on_uid", unique: true
  end

  create_table "organizations", id: :serial, force: :cascade do |t|
    t.string "access_token"
    t.string "stripe_publishable_key"
    t.string "stripe_user_id"
    t.string "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "slug"
    t.hstore "global_defaults"
    t.boolean "testmode"
    t.string "refresh_token"
    t.boolean "stripe_live_mode"
    t.string "stripe_publishable_test_key"
    t.string "stripe_test_access_token"
    t.index ["slug"], name: "index_organizations_on_slug", unique: true
    t.index ["stripe_user_id"], name: "index_organizations_on_stripe_user_id"
  end

  create_table "tag_namespaces", id: :serial, force: :cascade do |t|
    t.integer "organization_id"
    t.string "namespace"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["organization_id", "namespace"], name: "index_tag_namespaces_on_organization_id_and_namespace", unique: true
  end

  create_table "tags", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "organization_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "namespace_id"
    t.index ["organization_id", "name"], name: "index_tags_on_organization_id_and_name", unique: true
    t.index ["organization_id", "namespace_id"], name: "index_tags_on_organization_id_and_namespace_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "organization_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "admin", default: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["organization_id"], name: "index_users_on_organization_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "webhook_endpoints", id: :serial, force: :cascade do |t|
    t.integer "organization_id"
    t.text "url"
    t.string "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "username"
    t.string "password"
  end

end
