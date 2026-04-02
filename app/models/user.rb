class User < ApplicationRecord
  require 'digest'
  require 'securerandom'

  has_many :profiles, dependent: :destroy
  has_many :borrows, dependent: :destroy
  has_many :books, through: :borrows

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }, if: :new_record?
  validates :password, length: { minimum: 6 }, allow_blank: true, unless: :new_record?
  validate :passwords_match, if: :password_changed?

  accepts_nested_attributes_for :profiles, reject_if: :all_blank, allow_destroy: true

  enum user_type: { member: 'member', librarian: 'librarian' }

  attr_accessor :password, :password_confirmation

  before_create :hash_password

  # Scope to filter users by name (search)
  scope :search_by_name, ->(search) { where("name LIKE ?", "%#{search}%") }

  # Scope to filter users by a date range (created_at)
  scope :created_between_dates, ->(start_date, end_date) {
    where(created_at: start_date.beginning_of_day..end_date.end_of_day)
  }

  # Scope to order users by created_at and name
  scope :ordered_by_name_and_creation_date, -> { order(created_at: :asc, name: :asc) }

  # Authentication Methods
  def authenticate(password)
    return false if password_salt.blank?
    hash_password_with_salt(password, password_salt) == password_hash
  end

  def password_changed?
    !@password.nil?
  end

  # Methods
  def librarian?
    user_type == 'librarian'
  end

  def member?
    user_type == 'member'
  end

  def overdue_books
    borrows.overdue.includes(:book)
  end

  def active_borrows
    borrows.active.includes(:book)
  end

  private

  def hash_password
    if password.present?
      self.password_salt = SecureRandom.random_bytes(32)
      self.password_hash = hash_password_with_salt(password, password_salt)
    end
  end

  def hash_password_with_salt(password, salt)
    Digest::SHA256.digest(password + salt.to_s)
  end

  def passwords_match
    if password.present? && password != password_confirmation
      errors.add(:password_confirmation, "doesn't match Password")
    end
  end
end
