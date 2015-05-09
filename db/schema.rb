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

ActiveRecord::Schema.define(version: 20150128071640) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "brands", id: false, force: :cascade do |t|
    t.string "Brand", limit: 30, null: false
  end

  add_index "brands", ["Brand"], name: "index_brands_on_Brand", unique: true, using: :btree

  create_table "customers", primary_key: "CustID", force: :cascade do |t|
    t.string   "Name",            limit: 30,             null: false
    t.string   "Email",           limit: 30,             null: false
    t.string   "Gender",          limit: 1,              null: false
    t.string   "password_digest", limit: 60,             null: false
    t.float    "ShoeSize"
    t.float    "ShoeSizeError"
    t.integer  "ShoeCount",                  default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "genders", id: false, force: :cascade do |t|
    t.string "Gender", limit: 1, null: false
  end

  add_index "genders", ["Gender"], name: "index_genders_on_Gender", unique: true, using: :btree

  create_table "lengthfits", id: false, force: :cascade do |t|
    t.string "LengthFit", limit: 20, null: false
  end

  add_index "lengthfits", ["LengthFit"], name: "index_lengthfits_on_LengthFit", unique: true, using: :btree

  create_table "materials", id: false, force: :cascade do |t|
    t.string "Material", limit: 20, null: false
  end

  add_index "materials", ["Material"], name: "index_materials_on_Material", unique: true, using: :btree

  create_table "shoes", primary_key: "ShoeID", force: :cascade do |t|
    t.integer  "OwnerID",     limit: 8,  null: false
    t.integer  "T2RS_ID",     limit: 8,  null: false
    t.string   "Brand",       limit: 30, null: false
    t.string   "Style",       limit: 20, null: false
    t.string   "Material",    limit: 20, null: false
    t.string   "SizeType",    limit: 20, null: false
    t.string   "LengthFit",   limit: 20, null: false
    t.float    "Size",                   null: false
    t.float    "preRealSize"
    t.float    "RealSize"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sizetypes", id: false, force: :cascade do |t|
    t.string "SizeType",         limit: 20, null: false
    t.float  "ToMondo1",                    null: false
    t.float  "ToMondo0",                    null: false
    t.float  "SizeTypeInterval",            null: false
    t.float  "MinSize",                     null: false
    t.float  "MaxSize",                     null: false
  end

  add_index "sizetypes", ["SizeType"], name: "index_sizetypes_on_SizeType", unique: true, using: :btree

  create_table "styles", id: false, force: :cascade do |t|
    t.string "Style", limit: 20, null: false
  end

  add_index "styles", ["Style"], name: "index_styles_on_Style", unique: true, using: :btree

  create_table "typetorealsizes", primary_key: "T2RS_ID", force: :cascade do |t|
    t.string   "BrandStyleMaterial", limit: 70,                 null: false
    t.float    "ToMondo1",                      default: 1.0,   null: false
    t.float    "ToMondo0",                      default: 0.0,   null: false
    t.boolean  "modified",                      default: false, null: false
    t.float    "Uncertainty",                   default: 0.0
    t.integer  "shoeCount",                     default: 0,     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "typetorealsizes", ["BrandStyleMaterial"], name: "index_typetorealsizes_on_BrandStyleMaterial", unique: true, using: :btree

end
