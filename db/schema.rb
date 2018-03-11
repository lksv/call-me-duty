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

ActiveRecord::Schema.define(version: 20180311075636) do

  create_table "calendar_events", force: :cascade do |t|
    t.integer "calendar_id"
    t.integer "user_id"
    t.datetime "start_at", null: false
    t.datetime "end_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["calendar_id"], name: "index_calendar_events_on_calendar_id"
    t.index ["user_id"], name: "index_calendar_events_on_user_id"
  end

  create_table "calendars", force: :cascade do |t|
    t.integer "team_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id"], name: "index_calendars_on_team_id"
  end

  create_table "escalation_policies", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.text "description"
    t.integer "team_id"
    t.integer "clonned_from_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["clonned_from_id"], name: "index_escalation_policies_on_clonned_from_id"
    t.index ["name"], name: "index_escalation_policies_on_name"
    t.index ["team_id"], name: "index_escalation_policies_on_team_id"
  end

  create_table "escalation_rules", force: :cascade do |t|
    t.integer "escalation_policy_id"
    t.integer "condition_type", null: false
    t.integer "action_type", null: false
    t.integer "delay"
    t.string "target_type"
    t.integer "target_id"
    t.datetime "finished_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["escalation_policy_id"], name: "index_escalation_rules_on_escalation_policy_id"
    t.index ["target_type", "target_id"], name: "index_escalation_rules_on_target_type_and_target_id"
  end

  create_table "incidents", force: :cascade do |t|
    t.integer "status"
    t.string "title", limit: 127
    t.text "description"
    t.text "data"
    t.integer "team_id"
    t.integer "integration_id"
    t.integer "service_id"
    t.integer "escalation_policy_id"
    t.integer "priority"
    t.integer "alert_trigged_count"
    t.datetime "snoozed_until"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["escalation_policy_id"], name: "index_incidents_on_escalation_policy_id"
    t.index ["integration_id"], name: "index_incidents_on_integration_id"
    t.index ["service_id"], name: "index_incidents_on_service_id"
    t.index ["team_id"], name: "index_incidents_on_team_id"
  end

  create_table "integrations", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.string "key"
    t.string "type"
    t.integer "service_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_integrations_on_key"
    t.index ["name"], name: "index_integrations_on_name", unique: true
    t.index ["service_id"], name: "index_integrations_on_service_id"
  end

  create_table "services", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.text "description"
    t.integer "team_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_services_on_name", unique: true
    t.index ["team_id"], name: "index_services_on_team_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_teams_on_name", unique: true
  end

  create_table "teams_users", id: false, force: :cascade do |t|
    t.integer "team_id"
    t.integer "user_id"
    t.index ["team_id"], name: "index_teams_users_on_team_id"
    t.index ["user_id"], name: "index_teams_users_on_user_id"
  end

  create_table "users", force: :cascade do |t|
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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "phone"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "webhooks", force: :cascade do |t|
    t.integer "team_id"
    t.string "name"
    t.string "token"
    t.string "uri", limit: 2000
    t.string "template"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id"], name: "index_webhooks_on_team_id"
  end

end
