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

ActiveRecord::Schema.define(version: 20160601073025) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "abilities", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "active_admin_comments", force: :cascade do |t|
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

  create_table "admin_users", force: :cascade do |t|
    t.string   "email",                  default: "",   null: false
    t.string   "encrypted_password",     default: "",   null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,    null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.string   "role"
    t.boolean  "status",                 default: true
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

  create_table "advertisements", force: :cascade do |t|
    t.string   "title",       default: ""
    t.string   "image"
    t.text     "discription", default: ""
    t.integer  "user_id"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "advertisements", ["user_id"], name: "index_advertisements_on_user_id", using: :btree

  create_table "attendees", force: :cascade do |t|
    t.string   "title"
    t.string   "company"
    t.string   "address"
    t.string   "website"
    t.string   "email"
    t.string   "phone"
    t.string   "mobile"
    t.string   "approval_status"
    t.integer  "user_id"
    t.integer  "event_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "attendees", ["event_id"], name: "index_attendees_on_event_id", using: :btree
  add_index "attendees", ["user_id"], name: "index_attendees_on_user_id", using: :btree

  create_table "devices", force: :cascade do |t|
    t.string   "device_type"
    t.string   "device_id"
    t.integer  "user_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "devices", ["user_id"], name: "index_devices_on_user_id", using: :btree

  create_table "events", force: :cascade do |t|
    t.string   "name"
    t.string   "location"
    t.datetime "time"
    t.string   "organizer"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "events", ["user_id"], name: "index_events_on_user_id", using: :btree

  create_table "invitations", force: :cascade do |t|
    t.string   "sender_email"
    t.string   "reciever_email"
    t.string   "status"
    t.string   "event_name"
    t.string   "mode"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "notifications", force: :cascade do |t|
    t.string   "notification_type"
    t.string   "content"
    t.integer  "user_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "notifications", ["user_id"], name: "index_notifications_on_user_id", using: :btree

  create_table "posts", force: :cascade do |t|
    t.string   "title",      default: ""
    t.text     "content",    default: ""
    t.integer  "user_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "posts", ["user_id"], name: "index_posts_on_user_id", using: :btree

  create_table "social_codes", force: :cascade do |t|
    t.string   "code"
    t.string   "image"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "social_codes", ["user_id"], name: "index_social_codes_on_user_id", using: :btree

  create_table "social_logins", force: :cascade do |t|
    t.string   "provider"
    t.string   "u_id"
    t.string   "user_name"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "social_logins", ["user_id"], name: "index_social_logins_on_user_id", using: :btree

  create_table "static_pages", force: :cascade do |t|
    t.string   "title",      default: ""
    t.text     "content",    default: ""
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "user_invitations", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "invitation_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "user_invitations", ["invitation_id"], name: "index_user_invitations_on_invitation_id", using: :btree
  add_index "user_invitations", ["user_id"], name: "index_user_invitations_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "user_name",              default: ""
    t.string   "first_name",             default: ""
    t.string   "last_name",              default: ""
    t.boolean  "tc_accept",              default: false
    t.string   "image"
    t.string   "otp"
    t.string   "role",                   default: ""
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "address"
    t.float    "latitude"
    t.float    "longitude"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "videos", force: :cascade do |t|
    t.string   "content"
    t.integer  "user_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "title"
    t.text     "discription"
    t.boolean  "status",      default: true
  end

  add_index "videos", ["user_id"], name: "index_videos_on_user_id", using: :btree

  add_foreign_key "advertisements", "users"
  add_foreign_key "attendees", "events"
  add_foreign_key "attendees", "users"
  add_foreign_key "devices", "users"
  add_foreign_key "events", "users"
  add_foreign_key "notifications", "users"
  add_foreign_key "posts", "users"
  add_foreign_key "social_codes", "users"
  add_foreign_key "social_logins", "users"
  add_foreign_key "user_invitations", "invitations"
  add_foreign_key "user_invitations", "users"
  add_foreign_key "videos", "users"
end
