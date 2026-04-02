class CreateBorrows < ActiveRecord::Migration[7.0]
  def change
    create_table :borrows do |t|
      t.references :user, null: false, foreign_key: true
      t.references :book, null: false, foreign_key: true
      t.datetime :borrowed_at, null: false
      t.datetime :due_at, null: false
      t.datetime :returned_at

      t.timestamps
    end

    add_index :borrows, [:user_id, :book_id]
    add_index :borrows, [:book_id, :returned_at]
  end
end
