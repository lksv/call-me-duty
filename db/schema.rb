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

ActiveRecord::Schema.define(version: 20180330180723) do

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
    t.integer "current_calendar_event_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["current_calendar_event_id"], name: "index_calendars_on_current_calendar_event_id"
    t.index ["team_id"], name: "index_calendars_on_team_id"
  end

  create_table "delivery_gateways", force: :cascade do |t|
    t.string "name"
    t.string "type"
    t.integer "team_id"
    t.text "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id"], name: "index_delivery_gateways_on_team_id"
    t.index ["type"], name: "index_delivery_gateways_on_type"
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
    t.string "targetable_type"
    t.integer "targetable_id"
    t.datetime "finished_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["escalation_policy_id"], name: "index_escalation_rules_on_escalation_policy_id"
    t.index ["targetable_type", "targetable_id"], name: "index_escalation_rules_on_targetable_type_and_targetable_id"
  end

  create_table "incidents", force: :cascade do |t|
    t.integer "iid", null: false
    t.integer "status", default: 0
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
    t.index ["team_id", "iid"], name: "index_incidents_on_team_id_and_iid", unique: true
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

  create_table "members", force: :cascade do |t|
    t.string "type"
    t.integer "user_id"
    t.integer "team_id"
    t.integer "access_level", null: false
    t.integer "created_by_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_by_id"], name: "index_members_on_created_by_id"
    t.index ["team_id"], name: "index_members_on_team_id"
    t.index ["user_id"], name: "index_members_on_user_id"
  end

  create_table "messages", force: :cascade do |t|
    t.integer "status", null: false
    t.integer "event", null: false
    t.string "messageable_type"
    t.integer "messageable_id"
    t.string "static_gateway"
    t.integer "delivery_gateway_id"
    t.integer "user_id"
    t.datetime "delivered_at"
    t.string "gateway_request_uid"
    t.datetime "answered_at"
    t.datetime "ended_at"
    t.float "cost"
    t.integer "duration"
    t.text "error_msg", limit: 1024
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["delivery_gateway_id"], name: "index_messages_on_delivery_gateway_id"
    t.index ["event"], name: "index_messages_on_event"
    t.index ["messageable_type", "messageable_id"], name: "index_messages_on_messageable_type_and_messageable_id"
    t.index ["user_id"], name: "index_messages_on_user_id"
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
    t.string "type"
    t.text "description"
    t.integer "parent_id"
    t.integer "owner_id"
    t.string "slug", default: "", null: false
    t.string "full_path", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["full_path"], name: "index_teams_on_full_path", unique: true
    t.index ["owner_id"], name: "index_teams_on_owner_id"
    t.index ["parent_id", "name"], name: "index_teams_on_parent_id_and_name", unique: true
    t.index ["parent_id", "slug"], name: "index_teams_on_parent_id_and_slug", unique: true
    t.index ["parent_id"], name: "index_teams_on_parent_id"
    t.index ["type"], name: "index_teams_on_type"
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
    t.string "name"
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
