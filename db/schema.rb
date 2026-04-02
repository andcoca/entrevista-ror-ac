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

ActiveRecord::Schema[7.0].define(version: 2025_04_01_110000) do
  create_table "books", force: :cascade do |t|
    t.string "title", null: false
    t.string "author", null: false
    t.string "genre", null: false
    t.string "isbn", null: false
    t.integer "total_copies", default: 1, null: false
    t.integer "available_copies", default: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author"], name: "index_books_on_author"
    t.index ["genre"], name: "index_books_on_genre"
    t.index ["isbn"], name: "index_books_on_isbn", unique: true
    t.index ["title"], name: "index_books_on_title"
  end

  create_table "borrows", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "book_id", null: false
    t.datetime "borrowed_at", null: false
    t.datetime "due_at", null: false
    t.datetime "returned_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["book_id", "returned_at"], name: "index_borrows_on_book_id_and_returned_at"
    t.index ["book_id"], name: "index_borrows_on_book_id"
    t.index ["user_id", "book_id"], name: "index_borrows_on_user_id_and_book_id"
    t.index ["user_id"], name: "index_borrows_on_user_id"
  end

  create_table "profiles", force: :cascade do |t|
    t.integer "user_id", null: false
    t.text "bio"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_profiles_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "user_type", default: "member", null: false
    t.binary "password_hash"
    t.binary "password_salt"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "borrows", "books"
  add_foreign_key "borrows", "users"
  add_foreign_key "profiles", "users"
end
