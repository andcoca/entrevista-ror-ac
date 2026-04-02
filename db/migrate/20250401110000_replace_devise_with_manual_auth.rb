class ReplaceDeviseWithManualAuth < ActiveRecord::Migration[7.0]
  def change
    # Remove Devise columns if they exist
    if column_exists?(:users, :encrypted_password)
      remove_column :users, :encrypted_password
    end
    
    if column_exists?(:users, :reset_password_token)
      remove_column :users, :reset_password_token
    end
    
    if column_exists?(:users, :reset_password_sent_at)
      remove_column :users, :reset_password_sent_at
    end
    
    if column_exists?(:users, :remember_created_at)
      remove_column :users, :remember_created_at
    end
    
    if column_exists?(:users, :sign_in_count)
      remove_column :users, :sign_in_count
    end
    
    if column_exists?(:users, :current_sign_in_at)
      remove_column :users, :current_sign_in_at
    end
    
    if column_exists?(:users, :last_sign_in_at)
      remove_column :users, :last_sign_in_at
    end
    
    if column_exists?(:users, :current_sign_in_ip)
      remove_column :users, :current_sign_in_ip
    end
    
    if column_exists?(:users, :last_sign_in_ip)
      remove_column :users, :last_sign_in_ip
    end
    
    # Add manual authentication columns
    unless column_exists?(:users, :password_hash)
      add_column :users, :password_hash, :binary
    end
    
    unless column_exists?(:users, :password_salt)
      add_column :users, :password_salt, :binary
    end
  end
end
