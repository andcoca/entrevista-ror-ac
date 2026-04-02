class AddAuthenticationToUsers < ActiveRecord::Migration[7.0]
  def change
    # Devise fields
    add_column :users, :encrypted_password, :string, default: "", null: false
    add_column :users, :reset_password_token, :string
    add_column :users, :reset_password_sent_at, :datetime
    add_column :users, :remember_created_at, :datetime
    add_column :users, :sign_in_count, :integer, default: 0, null: false
    add_column :users, :current_sign_in_at, :datetime
    add_column :users, :last_sign_in_at, :datetime
    add_column :users, :current_sign_in_ip, :string
    add_column :users, :last_sign_in_ip, :string
    
    # User type for Librarian/Member roles
    add_column :users, :user_type, :string, default: 'member', null: false
    
    # Indexes
    add_index :users, :email, unique: true
    add_index :users, :reset_password_token, unique: true
  end
end
