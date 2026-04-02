class Borrow < ApplicationRecord
  belongs_to :user
  belongs_to :book

  validates :borrowed_at, :due_at, presence: true

  scope :active, -> { where(returned_at: nil) }
  scope :overdue, -> { active.where("due_at < ?", Time.current) }
  scope :due_today, -> { active.where("date(due_at) = ?", Date.current.to_s) }
  scope :returned, -> { where.not(returned_at: nil) }

  # Methods
  def overdue?
    returned_at.nil? && due_at < Time.current
  end

  def due_today?
    returned_at.nil? && due_at.to_date == Date.current
  end

  def return_book
    update(returned_at: Time.current)
    book.increment!(:available_copies)
  end

  def days_until_due
    ((due_at - Time.current) / 1.day).ceil
  end

  def days_overdue
    return 0 if !overdue?
    ((Time.current - due_at) / 1.day).ceil
  end
end
