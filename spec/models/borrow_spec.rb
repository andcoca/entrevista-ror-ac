require 'rails_helper'

RSpec.describe Borrow, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:book) }
  end

  describe 'validations' do
    subject { build(:borrow) }

    it { should validate_presence_of(:borrowed_at) }
    it { should validate_presence_of(:due_at) }
  end

  describe 'scopes' do
    before do
      @active_borrow = create(:borrow, returned_at: nil)
      @returned_borrow = create(:borrow, returned_at: 1.day.ago)
      @overdue_borrow = create(:borrow, returned_at: nil, due_at: 1.day.ago)
      @due_today_borrow = create(:borrow, returned_at: nil, due_at: Date.current.end_of_day)
    end

    describe '.active' do
      it 'returns only active borrows' do
        results = Borrow.active
        expect(results).to include(@active_borrow, @overdue_borrow, @due_today_borrow)
        expect(results).not_to include(@returned_borrow)
      end
    end

    describe '.overdue' do
      it 'returns only overdue borrows' do
        results = Borrow.overdue
        expect(results).to include(@overdue_borrow)
        expect(results).not_to include(@active_borrow, @returned_borrow, @due_today_borrow)
      end
    end

    describe '.returned' do
      it 'returns only returned borrows' do
        results = Borrow.returned
        expect(results).to include(@returned_borrow)
        expect(results).not_to include(@active_borrow, @overdue_borrow)
      end
    end

    describe '.due_today' do
      it 'returns borrows due today' do
        results = Borrow.due_today
        expect(results).to include(@due_today_borrow)
      end
    end
  end

  describe '#overdue?' do
    it 'returns true if returned_at is nil and due_at < Time.current' do
      borrow = build(:borrow, returned_at: nil, due_at: 1.day.ago)
      expect(borrow.overdue?).to be true
    end

    it 'returns false if returned_at is not nil' do
      borrow = build(:borrow, returned_at: 1.day.ago, due_at: 2.days.ago)
      expect(borrow.overdue?).to be false
    end

    it 'returns false if due_at is in the future' do
      borrow = build(:borrow, returned_at: nil, due_at: 1.day.from_now)
      expect(borrow.overdue?).to be false
    end
  end

  describe '#return_book' do
    it 'sets returned_at to current time' do
      borrow = create(:borrow, returned_at: nil)
      borrow.return_book
      expect(borrow.returned_at).to be_present
    end

    it 'increments book available_copies' do
      book = create(:book, available_copies: 3)
      borrow = create(:borrow, book: book)
      book.decrement!(:available_copies)

      borrow.return_book
      expect(book.reload.available_copies).to eq(3)
    end
  end

  describe '#days_until_due' do
    it 'returns the number of days until due date' do
      borrow = build(:borrow, due_at: 3.days.from_now)
      days = borrow.days_until_due
      expect(days).to be_within(1).of(3)
    end
  end

  describe '#due_today?' do
    it 'returns true when due today and not returned' do
      borrow = build(:borrow, returned_at: nil, due_at: Date.current.end_of_day)
      expect(borrow.due_today?).to be true
    end

    it 'returns false when not due today' do
      borrow = build(:borrow, returned_at: nil, due_at: 1.day.from_now)
      expect(borrow.due_today?).to be false
    end

    it 'returns false when already returned' do
      borrow = build(:borrow, returned_at: 1.hour.ago, due_at: Date.current.end_of_day)
      expect(borrow.due_today?).to be false
    end
  end

  describe '#days_overdue' do
    it 'returns 0 if not overdue' do
      borrow = build(:borrow, returned_at: nil, due_at: 1.day.from_now)
      expect(borrow.days_overdue).to eq(0)
    end

    it 'returns the number of days overdue' do
      borrow = build(:borrow, returned_at: nil, due_at: 3.days.ago)
      days = borrow.days_overdue
      expect(days).to be_within(1).of(3)
    end
  end
end
