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

ActiveRecord::Schema.define(version: 20160404163045) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "course_results", id: false, force: :cascade do |t|
    t.string  "student_code", limit: 10
    t.string  "course_code",  limit: 10
    t.integer "year"
    t.integer "semester"
    t.decimal "grade",                   precision: 4, scale: 2, null: false
    t.string  "situation",    limit: 30,                         null: false
  end

  create_table "courses", primary_key: "code", force: :cascade do |t|
    t.string  "name",     limit: 40, null: false
    t.integer "credits",             null: false
    t.integer "workload",            null: false
  end

  create_table "programs", primary_key: "code", force: :cascade do |t|
    t.string "name", limit: 80, null: false
  end

  create_table "students", primary_key: "code", force: :cascade do |t|
    t.integer "program_code",                          null: false
    t.decimal "average_grade", precision: 4, scale: 2, null: false
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
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "name"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "course_results", "courses", column: "course_code", primary_key: "code", name: "course_results_course_code_fkey", on_delete: :cascade
  add_foreign_key "course_results", "students", column: "student_code", primary_key: "code", name: "course_results_student_code_fkey", on_delete: :cascade
  add_foreign_key "students", "programs", column: "program_code", primary_key: "code", name: "students_program_code_fkey", on_delete: :cascade
end
