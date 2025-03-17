# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2025_03_16_204903) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "ai_providers", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ai_providers_geo_scorings", id: false, force: :cascade do |t|
    t.bigint "geo_scoring_id", null: false
    t.bigint "ai_provider_id", null: false
  end

  create_table "companies", force: :cascade do |t|
    t.string "name"
    t.string "domain"
    t.string "token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["user_id"], name: "index_companies_on_user_id"
  end

  create_table "company_ai_providers", force: :cascade do |t|
    t.bigint "company_id", null: false
    t.bigint "ai_provider_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ai_provider_id"], name: "index_company_ai_providers_on_ai_provider_id"
    t.index ["company_id"], name: "index_company_ai_providers_on_company_id"
  end

  create_table "competitor_scores", force: :cascade do |t|
    t.integer "score"
    t.integer "frequency_score"
    t.integer "position_score"
    t.integer "link_score"
    t.bigint "competitor_id", null: false
    t.bigint "geo_scoring_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["competitor_id"], name: "index_competitor_scores_on_competitor_id"
    t.index ["geo_scoring_id"], name: "index_competitor_scores_on_geo_scoring_id"
  end

  create_table "competitors", force: :cascade do |t|
    t.string "name"
    t.string "domain"
    t.bigint "company_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_competitors_on_company_id"
  end

  create_table "geo_scorings", force: :cascade do |t|
    t.integer "score"
    t.integer "frequency_score"
    t.integer "position_score"
    t.integer "link_score"
    t.bigint "keyword_id", null: false
    t.bigint "ai_provider_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.json "ai_responses", default: []
    t.boolean "url_presence"
    t.string "url_value"
    t.integer "reference_score"
    t.index ["ai_provider_id"], name: "index_geo_scorings_on_ai_provider_id"
    t.index ["keyword_id"], name: "index_geo_scorings_on_keyword_id"
  end

  create_table "keywords", force: :cascade do |t|
    t.string "content"
    t.bigint "company_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_keywords_on_company_id"
  end

  create_table "requests", force: :cascade do |t|
    t.string "domain"
    t.string "path"
    t.string "referrer"
    t.string "user_agent"
    t.bigint "company_id", null: false
    t.bigint "ai_provider_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ai_provider_id"], name: "index_requests_on_ai_provider_id"
    t.index ["company_id"], name: "index_requests_on_company_id"
  end

  create_table "resources", force: :cascade do |t|
    t.string "title"
    t.string "slug"
    t.text "content"
    t.text "summary"
    t.boolean "featured"
    t.datetime "published_at"
    t.string "category"
    t.string "author"
    t.string "cover_image"
    t.integer "reading_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "solid_cable_messages", force: :cascade do |t|
    t.text "channel"
    t.text "payload"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["channel"], name: "index_solid_cable_messages_on_channel"
    t.index ["created_at"], name: "index_solid_cable_messages_on_created_at"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.bigint "company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_users_on_company_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "companies", "users"
  add_foreign_key "company_ai_providers", "ai_providers"
  add_foreign_key "company_ai_providers", "companies"
  add_foreign_key "competitor_scores", "competitors"
  add_foreign_key "competitor_scores", "geo_scorings"
  add_foreign_key "competitors", "companies"
  add_foreign_key "geo_scorings", "ai_providers"
  add_foreign_key "geo_scorings", "keywords"
  add_foreign_key "keywords", "companies"
  add_foreign_key "requests", "ai_providers"
  add_foreign_key "requests", "companies"
  add_foreign_key "users", "companies"
end
