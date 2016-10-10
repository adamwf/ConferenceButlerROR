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


ActiveRecord::Schema.define(version: 20161010102158) do

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

  create_table "activities", force: :cascade do |t|
    t.string   "activity_type"
    t.integer  "item_id"
    t.string   "item_type"
    t.text     "message",       default: ""
    t.integer  "shared_id"
    t.boolean  "read",          default: false
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "activities", ["user_id"], name: "index_activities_on_user_id", using: :btree

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
    t.boolean  "feeds",                  default: true
    t.boolean  "adds",                   default: true
    t.boolean  "shop",                   default: true
    t.boolean  "discover",               default: true
    t.string   "user_name"
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

  create_table "advertisements", force: :cascade do |t|
    t.string   "title",       default: ""
    t.string   "image"
    t.text     "discription", default: ""
    t.integer  "user_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "status",      default: true
    t.integer  "priority"
    t.string   "category"
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
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.datetime "start_time"
    t.datetime "end_time"
    t.string   "category"
    t.string   "event_type"
    t.integer  "no_of_availability"
    t.boolean  "availability"
    t.integer  "user_id"
  end

  add_index "events", ["user_id"], name: "index_events_on_user_id", using: :btree

  create_table "forward_profiles", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "forward_profiles", ["user_id"], name: "index_forward_profiles_on_user_id", using: :btree

  create_table "friendships", force: :cascade do |t|
    t.integer "friendable_id"
    t.integer "friend_id"
    t.integer "blocker_id"
    t.boolean "pending",       default: true
    t.string  "keyword",       default: ""
  end

  add_index "friendships", ["friendable_id", "friend_id"], name: "index_friendships_on_friendable_id_and_friend_id", unique: true, using: :btree

  create_table "group_memberships", force: :cascade do |t|
    t.integer  "group_id"
    t.integer  "user_id"
    t.boolean  "is_mute",    default: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "group_memberships", ["group_id"], name: "index_group_memberships_on_group_id", using: :btree
  add_index "group_memberships", ["user_id"], name: "index_group_memberships_on_user_id", using: :btree

  create_table "groups", force: :cascade do |t|
    t.string   "group_name"
    t.string   "group_image"
    t.integer  "user_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "groups", ["user_id"], name: "index_groups_on_user_id", using: :btree

  create_table "invitations", force: :cascade do |t|
    t.integer  "sender_id"
    t.integer  "reciever_id"
    t.string   "status",      default: "pending"
    t.integer  "event_id"
    t.boolean  "mode",        default: true
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  add_index "invitations", ["event_id"], name: "index_invitations_on_event_id", using: :btree

  create_table "invite_managers", force: :cascade do |t|
    t.integer  "sender_id"
    t.integer  "reciever_id"
    t.string   "company_name"
    t.string   "email"
    t.integer  "event_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "invite_managers", ["event_id"], name: "index_invite_managers_on_event_id", using: :btree

  create_table "messages", force: :cascade do |t|
    t.integer  "sender_id"
    t.integer  "assoc_id"
    t.text     "body"
    t.string   "image"
    t.string   "video"
    t.boolean  "read_status",       default: true
    t.boolean  "is_group",          default: true
    t.integer  "room_id"
    t.string   "upload_type"
    t.string   "read_by",           default: [],                array: true
    t.string   "created_timestamp"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  add_index "messages", ["room_id"], name: "index_messages_on_room_id", using: :btree

  create_table "notifications", force: :cascade do |t|
    t.string   "notification_type"
    t.string   "content"
    t.integer  "user_id"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.boolean  "status",            default: false
    t.string   "subject"
    t.integer  "reciever_id"
    t.integer  "notifiable_id"
    t.string   "notifiable_type"
  end

  add_index "notifications", ["user_id"], name: "index_notifications_on_user_id", using: :btree

  create_table "otp_infos", force: :cascade do |t|
    t.string   "email"
    t.string   "otp"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "posts", force: :cascade do |t|
    t.string   "title",      default: ""
    t.text     "content",    default: ""
    t.integer  "user_id"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.boolean  "status",     default: true
    t.string   "category"
  end

  add_index "posts", ["user_id"], name: "index_posts_on_user_id", using: :btree

  create_table "profile_show_statuses", force: :cascade do |t|
    t.boolean  "name",            default: true
    t.boolean  "email",           default: true
    t.boolean  "phone",           default: true
    t.boolean  "other_info",      default: true
    t.boolean  "hobbies",         default: true
    t.boolean  "relation_status", default: true
    t.boolean  "children",        default: true
    t.boolean  "image",           default: true
    t.boolean  "facebook",        default: true
    t.boolean  "google",          default: true
    t.boolean  "linked_in",       default: true
    t.boolean  "instagram",       default: true
    t.boolean  "twitter",         default: true
    t.boolean  "social_code",     default: true
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.boolean  "address",         default: true
    t.integer  "user_id"
  end

  add_index "profile_show_statuses", ["user_id"], name: "index_profile_show_statuses_on_user_id", using: :btree

  create_table "profile_views", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "viewer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "profile_views", ["user_id"], name: "index_profile_views_on_user_id", using: :btree

  create_table "reminders", force: :cascade do |t|
    t.integer  "user_id"
    t.boolean  "status",     default: false
    t.string   "delay_time"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "reminders", ["user_id"], name: "index_reminders_on_user_id", using: :btree

  create_table "rooms", force: :cascade do |t|
    t.integer  "sender_id"
    t.integer  "assoc_id"
    t.boolean  "is_group",   default: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

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
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.boolean  "login_status"
  end

  add_index "social_logins", ["user_id"], name: "index_social_logins_on_user_id", using: :btree

  create_table "static_pages", force: :cascade do |t|
    t.string   "title",      default: ""
    t.text     "content",    default: ""
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "statuses", force: :cascade do |t|
    t.string   "last_seen"
    t.string   "current_status"
    t.integer  "user_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "statuses", ["user_id"], name: "index_statuses_on_user_id", using: :btree

  create_table "trendings", force: :cascade do |t|
    t.integer  "count"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "trendings", ["user_id"], name: "index_trendings_on_user_id", using: :btree

  create_table "user_events", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "event_id"
    t.boolean  "status",     default: false
    t.string   "qr_image"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "user_events", ["event_id"], name: "index_user_events_on_event_id", using: :btree
  add_index "user_events", ["user_id"], name: "index_user_events_on_user_id", using: :btree

  create_table "user_invitations", force: :cascade do |t|
    t.integer  "event_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "user_invitations", ["event_id"], name: "index_user_invitations_on_event_id", using: :btree
  add_index "user_invitations", ["user_id"], name: "index_user_invitations_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                                  default: "",    null: false
    t.string   "encrypted_password",                     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "user_name",                              default: ""
    t.string   "first_name",                             default: ""
    t.string   "last_name",                              default: ""
    t.boolean  "tc_accept",                              default: false
    t.string   "image"
    t.string   "otp"
    t.string   "role",                                   default: ""
    t.datetime "created_at",                                             null: false
    t.datetime "updated_at",                                             null: false
    t.string   "address"
    t.float    "latitude"
    t.float    "longitude"
    t.boolean  "status",                                 default: true
    t.string   "phone"
    t.string   "provider"
    t.string   "u_id"
    t.string   "company_name"
    t.string   "company_website"
    t.string   "fax"
    t.string   "facebook"
    t.string   "instagram"
    t.string   "youtube"
    t.string   "access_token"
    t.string   "hobbies"
    t.string   "relation_status"
    t.string   "children"
    t.boolean  "availability",                           default: true
    t.text     "other_info"
    t.boolean  "profile_view_to_requested_users"
    t.boolean  "profile_view_to_handle_directory_users"
    t.boolean  "profile_view_to_gab_users"
    t.integer  "reference_id"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "videos", force: :cascade do |t|
    t.string   "content"
    t.integer  "user_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "title",       default: ""
    t.text     "discription", default: ""
    t.boolean  "status",      default: true
    t.string   "category"
  end

  add_index "videos", ["user_id"], name: "index_videos_on_user_id", using: :btree

  add_foreign_key "advertisements", "users"
  add_foreign_key "attendees", "events"
  add_foreign_key "attendees", "users"
  add_foreign_key "devices", "users"
  add_foreign_key "events", "users"
  add_foreign_key "forward_profiles", "users"
  add_foreign_key "group_memberships", "groups"
  add_foreign_key "group_memberships", "users"
  add_foreign_key "groups", "users"
  add_foreign_key "invitations", "events"
  add_foreign_key "invite_managers", "events"
  add_foreign_key "messages", "rooms"
  add_foreign_key "notifications", "users"
  add_foreign_key "posts", "users"
  add_foreign_key "profile_show_statuses", "users"
  add_foreign_key "profile_views", "users"
  add_foreign_key "reminders", "users"
  add_foreign_key "social_codes", "users"
  add_foreign_key "social_logins", "users"
  add_foreign_key "statuses", "users"
  add_foreign_key "trendings", "users"
  add_foreign_key "user_events", "events"
  add_foreign_key "user_events", "users"
  add_foreign_key "user_invitations", "events"
  add_foreign_key "user_invitations", "users"
  add_foreign_key "videos", "users"
end
