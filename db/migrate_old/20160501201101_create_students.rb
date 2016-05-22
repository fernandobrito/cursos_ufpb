# Create students table
class CreateStudents < ActiveRecord::Migration
  def change
    create_table :students, id: false do |t|
      t.string :code, index: true, unique: true, null: false
      t.references :program, index: true, foreign_key: true, null: false
      t.decimal :average_grade, precision: 4, scale: 2

      t.timestamps null: false
    end
  end
end
