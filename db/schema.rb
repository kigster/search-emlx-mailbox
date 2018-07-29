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

ActiveRecord::Schema.define(version: 2013_07_08_015623) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "emails", force: :cascade do |t|
    t.text "header"
    t.text "from"
    t.text "to"
    t.text "cc"
    t.text "subject"
    t.text "body"
    t.datetime "received"
    t.string "file_name"
    t.index ["file_name"], name: "index_emails_on_file_name"
    t.index ["from", "received"], name: "index_emails_on_from_and_received"
    t.index ["received"], name: "index_emails_on_received"
  end

end
