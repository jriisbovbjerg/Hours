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

ActiveRecord::Schema.define(version: 20181011110314) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string   "subdomain",  default: "", null: false
    t.integer  "owner_id",   default: 0,  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "audits", force: :cascade do |t|
    t.integer  "auditable_id"
    t.string   "auditable_type"
    t.integer  "associated_id"
    t.string   "associated_type"
    t.integer  "user_id"
    t.string   "user_type"
    t.string   "username"
    t.string   "action"
    t.text     "audited_changes"
    t.integer  "version",         default: 0
    t.string   "comment"
    t.string   "remote_address"
    t.string   "request_uuid"
    t.datetime "created_at"
  end

  add_index "audits", ["associated_id", "associated_type"], name: "associated_index", using: :btree
  add_index "audits", ["auditable_id", "auditable_type"], name: "auditable_index", using: :btree
  add_index "audits", ["created_at"], name: "index_audits_on_created_at", using: :btree
  add_index "audits", ["request_uuid"], name: "index_audits_on_request_uuid", using: :btree
  add_index "audits", ["user_id", "user_type"], name: "user_index", using: :btree

  create_table "categories", force: :cascade do |t|
    t.string   "name",       default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "clients", force: :cascade do |t|
    t.string   "name",                        default: "", null: false
    t.string   "description",                 default: ""
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size",    limit: 8
    t.datetime "logo_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "companyname",                 default: "", null: false
    t.string   "adress",                      default: "", null: false
    t.string   "postalcode",                  default: "", null: false
    t.string   "otherinfo",                   default: "", null: false
    t.string   "invoiceemail",                default: "", null: false
    t.string   "paymentterms",                default: "", null: false
  end

  create_table "contacts", force: :cascade do |t|
    t.string   "name",       default: "", null: false
    t.string   "email",      default: "", null: false
    t.string   "position",   default: "", null: false
    t.string   "department", default: "", null: false
    t.string   "phone",      default: "", null: false
    t.integer  "client_id",               null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "contacts", ["client_id"], name: "index_contacts_on_client_id", using: :btree

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "expenses", force: :cascade do |t|
    t.integer  "project_id",                                                              null: false
    t.integer  "user_id",                                                                 null: false
    t.decimal  "value",                          precision: 10, scale: 2,                 null: false
    t.string   "currency",                                                default: "DKK", null: false
    t.decimal  "exchangerate",                   precision: 10, scale: 2, default: 1.0,   null: false
    t.string   "supplier",                                                                null: false
    t.string   "description",                                                             null: false
    t.date     "date",                                                                    null: false
    t.boolean  "billed",                                                  default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "amount",                         precision: 10, scale: 2,                 null: false
    t.string   "receipt_file_name"
    t.string   "receipt_content_type"
    t.integer  "receipt_file_size",    limit: 8
    t.datetime "receipt_updated_at"
  end

  add_index "expenses", ["billed"], name: "index_expenses_on_billed", using: :btree
  add_index "expenses", ["date"], name: "index_expenses_on_date", using: :btree
  add_index "expenses", ["project_id"], name: "index_expenses_on_project_id", using: :btree
  add_index "expenses", ["user_id"], name: "index_expenses_on_user_id", using: :btree

  create_table "hours", force: :cascade do |t|
    t.integer  "project_id",                                           null: false
    t.integer  "category_id",                                          null: false
    t.integer  "user_id",                                              null: false
    t.decimal  "value",       precision: 10, scale: 2,                 null: false
    t.date     "date",                                                 null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "description"
    t.boolean  "billed",                               default: false
  end

  add_index "hours", ["billed"], name: "index_hours_on_billed", using: :btree
  add_index "hours", ["category_id"], name: "index_hours_on_category_id", using: :btree
  add_index "hours", ["date"], name: "index_hours_on_date", using: :btree
  add_index "hours", ["project_id"], name: "index_hours_on_project_id", using: :btree
  add_index "hours", ["user_id"], name: "index_hours_on_user_id", using: :btree

  create_table "mileages", force: :cascade do |t|
    t.integer  "project_id",                  null: false
    t.integer  "user_id",                     null: false
    t.integer  "value",                       null: false
    t.date     "date",                        null: false
    t.boolean  "billed",      default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "from_adress",                 null: false
    t.string   "to_adress",                   null: false
    t.boolean  "taxfree",     default: false
  end

  add_index "mileages", ["billed"], name: "index_mileages_on_billed", using: :btree
  add_index "mileages", ["date"], name: "index_mileages_on_date", using: :btree
  add_index "mileages", ["project_id"], name: "index_mileages_on_project_id", using: :btree
  add_index "mileages", ["user_id"], name: "index_mileages_on_user_id", using: :btree

  create_table "projects", force: :cascade do |t|
    t.string   "name",             default: "",                           null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
    t.integer  "budget"
    t.boolean  "billable",         default: false
    t.integer  "client_id"
    t.boolean  "archived",         default: false,                        null: false
    t.text     "description"
    t.integer  "contact_id"
    t.string   "currency",         default: "EUR",                        null: false
    t.string   "period",           default: "hourly",                     null: false
    t.string   "valid_from",       default: "--- !ruby/object:Proc {}\n", null: false
    t.string   "valid_to",         default: "--- !ruby/object:Proc {}\n", null: false
    t.string   "invoice_email",    default: "",                           null: false
    t.string   "reference_number", default: "",                           null: false
  end

  add_index "projects", ["archived"], name: "index_projects_on_archived", using: :btree
  add_index "projects", ["billable"], name: "index_projects_on_billable", using: :btree
  add_index "projects", ["slug"], name: "index_projects_on_slug", using: :btree

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id"
    t.integer  "hour_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "taggings", ["hour_id"], name: "index_taggings_on_hour_id", using: :btree
  add_index "taggings", ["tag_id"], name: "index_taggings_on_tag_id", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
  end

  add_index "tags", ["slug"], name: "index_tags_on_slug", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "first_name",             default: "", null: false
    t.string   "last_name",              default: "", null: false
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: ""
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
    t.integer  "organization_id"
    t.string   "slug"
    t.string   "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
    t.integer  "invitations_count",      default: 0
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["invitation_token"], name: "index_users_on_invitation_token", unique: true, using: :btree
  add_index "users", ["invitations_count"], name: "index_users_on_invitations_count", using: :btree
  add_index "users", ["invited_by_id"], name: "index_users_on_invited_by_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["slug"], name: "index_users_on_slug", using: :btree

end
