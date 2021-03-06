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

ActiveRecord::Schema.define(version: 20170821144652) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "comfy_cms_blocks", force: :cascade do |t|
    t.string   "identifier",     null: false
    t.text     "content"
    t.string   "blockable_type"
    t.integer  "blockable_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["blockable_id", "blockable_type"], name: "index_comfy_cms_blocks_on_blockable_id_and_blockable_type", using: :btree
    t.index ["identifier"], name: "index_comfy_cms_blocks_on_identifier", using: :btree
  end

  create_table "comfy_cms_categories", force: :cascade do |t|
    t.integer "site_id",          null: false
    t.string  "label",            null: false
    t.string  "categorized_type", null: false
    t.index ["site_id", "categorized_type", "label"], name: "index_cms_categories_on_site_id_and_cat_type_and_label", unique: true, using: :btree
  end

  create_table "comfy_cms_categorizations", force: :cascade do |t|
    t.integer "category_id",      null: false
    t.string  "categorized_type", null: false
    t.integer "categorized_id",   null: false
    t.index ["category_id", "categorized_type", "categorized_id"], name: "index_cms_categorizations_on_cat_id_and_catd_type_and_catd_id", unique: true, using: :btree
  end

  create_table "comfy_cms_files", force: :cascade do |t|
    t.integer  "site_id",                                    null: false
    t.integer  "block_id"
    t.string   "label",                                      null: false
    t.string   "file_file_name",                             null: false
    t.string   "file_content_type",                          null: false
    t.integer  "file_file_size",                             null: false
    t.string   "description",       limit: 2048
    t.integer  "position",                       default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["site_id", "block_id"], name: "index_comfy_cms_files_on_site_id_and_block_id", using: :btree
    t.index ["site_id", "file_file_name"], name: "index_comfy_cms_files_on_site_id_and_file_file_name", using: :btree
    t.index ["site_id", "label"], name: "index_comfy_cms_files_on_site_id_and_label", using: :btree
    t.index ["site_id", "position"], name: "index_comfy_cms_files_on_site_id_and_position", using: :btree
  end

  create_table "comfy_cms_layouts", force: :cascade do |t|
    t.integer  "site_id",                    null: false
    t.integer  "parent_id"
    t.string   "app_layout"
    t.string   "label",                      null: false
    t.string   "identifier",                 null: false
    t.text     "content"
    t.text     "css"
    t.text     "js"
    t.integer  "position",   default: 0,     null: false
    t.boolean  "is_shared",  default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["parent_id", "position"], name: "index_comfy_cms_layouts_on_parent_id_and_position", using: :btree
    t.index ["site_id", "identifier"], name: "index_comfy_cms_layouts_on_site_id_and_identifier", unique: true, using: :btree
  end

  create_table "comfy_cms_pages", force: :cascade do |t|
    t.integer  "site_id",                        null: false
    t.integer  "layout_id"
    t.integer  "parent_id"
    t.integer  "target_page_id"
    t.string   "label",                          null: false
    t.string   "slug"
    t.string   "full_path",                      null: false
    t.text     "content_cache"
    t.integer  "position",       default: 0,     null: false
    t.integer  "children_count", default: 0,     null: false
    t.boolean  "is_published",   default: true,  null: false
    t.boolean  "is_shared",      default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["parent_id", "position"], name: "index_comfy_cms_pages_on_parent_id_and_position", using: :btree
    t.index ["site_id", "full_path"], name: "index_comfy_cms_pages_on_site_id_and_full_path", using: :btree
  end

  create_table "comfy_cms_revisions", force: :cascade do |t|
    t.string   "record_type", null: false
    t.integer  "record_id",   null: false
    t.text     "data"
    t.datetime "created_at"
    t.index ["record_type", "record_id", "created_at"], name: "index_cms_revisions_on_rtype_and_rid_and_created_at", using: :btree
  end

  create_table "comfy_cms_sites", force: :cascade do |t|
    t.string  "label",                       null: false
    t.string  "identifier",                  null: false
    t.string  "hostname",                    null: false
    t.string  "path"
    t.string  "locale",      default: "en",  null: false
    t.boolean "is_mirrored", default: false, null: false
    t.index ["hostname"], name: "index_comfy_cms_sites_on_hostname", using: :btree
    t.index ["is_mirrored"], name: "index_comfy_cms_sites_on_is_mirrored", using: :btree
  end

  create_table "comfy_cms_snippets", force: :cascade do |t|
    t.integer  "site_id",                    null: false
    t.string   "label",                      null: false
    t.string   "identifier",                 null: false
    t.text     "content"
    t.integer  "position",   default: 0,     null: false
    t.boolean  "is_shared",  default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["site_id", "identifier"], name: "index_comfy_cms_snippets_on_site_id_and_identifier", unique: true, using: :btree
    t.index ["site_id", "position"], name: "index_comfy_cms_snippets_on_site_id_and_position", using: :btree
  end

  create_table "electricity_products", id: false, force: :cascade do |t|
    t.integer  "matrix_id"
    t.integer  "profile_class"
    t.integer  "duration"
    t.string   "distribution_area"
    t.string   "rate1_name"
    t.decimal  "rate1",                precision: 8, scale: 4
    t.string   "rate2_name"
    t.decimal  "rate2",                precision: 8, scale: 4
    t.decimal  "standing_charge_rate", precision: 8, scale: 4
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.index ["distribution_area"], name: "index_electricity_products_on_distribution_area", using: :btree
    t.index ["matrix_id"], name: "index_electricity_products_on_matrix_id", unique: true, using: :btree
    t.index ["profile_class"], name: "index_electricity_products_on_profile_class", using: :btree
  end

  create_table "electricity_products_upload", id: false, force: :cascade do |t|
    t.integer  "matrix_id",                                    null: false
    t.integer  "profile_class",                                null: false
    t.integer  "duration",                                     null: false
    t.string   "distribution_area",                            null: false
    t.string   "rate1_name",                                   null: false
    t.decimal  "rate1",                precision: 8, scale: 4, null: false
    t.string   "rate2_name",                                   null: false
    t.decimal  "rate2",                precision: 8, scale: 4, null: false
    t.decimal  "standing_charge_rate", precision: 8, scale: 4, null: false
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
  end

  create_table "flipper_features", force: :cascade do |t|
    t.string   "key",        null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_flipper_features_on_key", unique: true, using: :btree
  end

  create_table "flipper_gates", force: :cascade do |t|
    t.string   "feature_key", null: false
    t.string   "key",         null: false
    t.string   "value"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["feature_key", "key", "value"], name: "index_flipper_gates_on_feature_key_and_key_and_value", unique: true, using: :btree
  end

  create_table "gas_postcodes", id: false, force: :cascade do |t|
    t.string   "postcode"
    t.string   "zone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["postcode"], name: "index_gas_postcodes_on_postcode", unique: true, using: :btree
    t.index ["zone"], name: "index_gas_postcodes_on_zone", using: :btree
  end

  create_table "gas_products", id: false, force: :cascade do |t|
    t.integer  "matrix_id"
    t.string   "end_user_category"
    t.string   "distribution_zone"
    t.string   "exit_zone"
    t.integer  "lower_limit_aq"
    t.integer  "upper_limit_aq"
    t.integer  "estimated_aq"
    t.string   "broker"
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "duration"
    t.decimal  "rate",                 precision: 8, scale: 4
    t.decimal  "standing_charge_rate", precision: 8, scale: 4
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.index ["distribution_zone"], name: "index_gas_products_on_distribution_zone", using: :btree
    t.index ["matrix_id"], name: "index_gas_products_on_matrix_id", unique: true, using: :btree
  end

  create_table "gas_products_upload", id: false, force: :cascade do |t|
    t.integer  "matrix_id"
    t.string   "end_user_category"
    t.string   "distribution_zone"
    t.string   "exit_zone"
    t.integer  "lower_limit_aq"
    t.integer  "upper_limit_aq"
    t.integer  "estimated_aq"
    t.string   "broker"
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "duration"
    t.decimal  "rate",                 precision: 8, scale: 4
    t.decimal  "standing_charge_rate", precision: 8, scale: 4
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
  end

  create_table "quotes", force: :cascade do |t|
    t.string   "postcode"
    t.string   "product_type"
    t.text     "address"
    t.string   "mpan"
    t.string   "mprn"
    t.integer  "usage"
    t.integer  "cost"
    t.integer  "usage_or_cost_period"
    t.json     "presented_products"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.index ["postcode"], name: "index_quotes_on_postcode", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "name"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "role"
    t.string   "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.string   "invited_by_type"
    t.integer  "invited_by_id"
    t.integer  "invitations_count",      default: 0
    t.integer  "failed_attempts",        default: 0,  null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true, using: :btree
    t.index ["invitations_count"], name: "index_users_on_invitations_count", using: :btree
    t.index ["invited_by_id"], name: "index_users_on_invited_by_id", using: :btree
    t.index ["invited_by_type", "invited_by_id"], name: "index_users_on_invited_by_type_and_invited_by_id", using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree
  end

end
