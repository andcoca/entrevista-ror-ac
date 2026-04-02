class Book < ApplicationRecord
  has_many :borrows, dependent: :destroy
  has_many :users, through: :borrows

  validates :title, :author, :genre, :isbn, :total_copies, presence: true
  validates :isbn, uniqueness: { case_sensitive: true }
  validates :total_copies, :available_copies, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  # Scopes for searching (portable across PostgreSQL/SQLite)
  scope :search_by_title, ->(title) {
    where('LOWER(title) LIKE ?', "%#{sanitize_sql_like(title.to_s.downcase)}%")
  }
  scope :search_by_author, ->(author) {
    where('LOWER(author) LIKE ?', "%#{sanitize_sql_like(author.to_s.downcase)}%")
  }
  scope :search_by_genre, ->(genre) {
    where('LOWER(genre) LIKE ?', "%#{sanitize_sql_like(genre.to_s.downcase)}%")
  }
  scope :available, -> { where('available_copies > 0') }

  # Methods
  def available?
    available_copies > 0
  end

  def borrow_by_user(user)
    return nil if already_borrowed_by?(user)
    return nil unless available?

    transaction do
      borrow = borrows.create!(
        user: user,
        borrowed_at: Time.current,
        due_at: 2.weeks.from_now
      )

      decrement!(:available_copies)
      borrow
    end
  rescue ActiveRecord::RecordInvalid
    nil
  end

  def already_borrowed_by?(user)
    borrows.where(user: user, returned_at: nil).exists?
  end

  def current_borrower(user)
    borrows.where(user: user, returned_at: nil).first
  end
end
