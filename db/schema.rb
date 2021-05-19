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

ActiveRecord::Schema.define(version: 2021_05_19_091221) do

  create_table "activities", force: :cascade do |t|
    t.string "name"
    t.string "responsible"
    t.datetime "initial_date"
    t.datetime "final_date"
    t.datetime "result_date"
    t.decimal "grade"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "activities_questions", force: :cascade do |t|
    t.integer "activity_id", null: false
    t.integer "question_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["activity_id"], name: "index_activities_questions_on_activity_id"
    t.index ["question_id"], name: "index_activities_questions_on_question_id"
  end

  create_table "activities_users", force: :cascade do |t|
    t.integer "activity_id", null: false
    t.integer "user_id", null: false
    t.datetime "user_initial_date"
    t.datetime "user_final_date"
    t.datetime "user_result_date"
    t.decimal "user_grade"
    t.string "status"
    t.integer "last_question"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["activity_id"], name: "index_activities_users_on_activity_id"
    t.index ["user_id"], name: "index_activities_users_on_user_id"
  end

  create_table "activity_user_answers", force: :cascade do |t|
    t.integer "activities_users_id", null: false
    t.json "answers"
    t.integer "decision_id"
    t.integer "sanction_id"
    t.text "open_question"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["activities_users_id"], name: "index_activity_user_answers_on_activities_users_id"
    t.index ["decision_id"], name: "index_activity_user_answers_on_decision_id"
    t.index ["sanction_id"], name: "index_activity_user_answers_on_sanction_id"
  end

  create_table "answers", force: :cascade do |t|
    t.string "description"
    t.string "option"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "question_id", null: false
    t.index ["question_id"], name: "index_answers_on_question_id"
  end

  create_table "clips", force: :cascade do |t|
    t.string "clipName"
    t.string "uploadUser"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "video"
    t.integer "decision_id"
    t.integer "sanction_id"
    t.integer "question_id"
    t.index ["decision_id"], name: "index_clips_on_decision_id"
    t.index ["question_id"], name: "index_clips_on_question_id"
    t.index ["sanction_id"], name: "index_clips_on_sanction_id"
  end

  create_table "clips_topics", force: :cascade do |t|
    t.integer "clip_id", null: false
    t.integer "topic_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["clip_id"], name: "index_clips_topics_on_clip_id"
    t.index ["topic_id"], name: "index_clips_topics_on_topic_id"
  end

  create_table "decisions", force: :cascade do |t|
    t.string "description"
    t.string "initials"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "images", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "profiles", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "questions", force: :cascade do |t|
    t.string "question"
    t.string "question_type"
    t.decimal "response_time"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "clip_id"
    t.index ["clip_id"], name: "index_questions_on_clip_id"
  end

  create_table "sanctions", force: :cascade do |t|
    t.string "description"
    t.string "initials"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "topics", force: :cascade do |t|
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "surname"
    t.string "email"
    t.string "password"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "profile_id", null: false
    t.index ["profile_id"], name: "index_users_on_profile_id"
  end

  add_foreign_key "activities_questions", "activities"
  add_foreign_key "activities_questions", "questions"
  add_foreign_key "activities_users", "activities"
  add_foreign_key "activities_users", "users"
  add_foreign_key "activity_user_answers", "activities_users", column: "activities_users_id"
  add_foreign_key "activity_user_answers", "decisions"
  add_foreign_key "activity_user_answers", "sanctions"
  add_foreign_key "answers", "questions"
  add_foreign_key "clips", "decisions"
  add_foreign_key "clips", "questions"
  add_foreign_key "clips", "sanctions"
  add_foreign_key "clips_topics", "clips"
  add_foreign_key "clips_topics", "topics"
  add_foreign_key "questions", "clips"
  add_foreign_key "users", "profiles"
end
