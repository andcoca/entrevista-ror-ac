require 'rails_helper'

RSpec.describe Book, type: :model do
  describe 'associations' do
    it { should have_many(:borrows).dependent(:destroy) }
    it { should have_many(:users).through(:borrows) }
  end

  describe 'validations' do
    subject { build(:book) }

    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:author) }
    it { should validate_presence_of(:genre) }
    it { should validate_presence_of(:isbn) }
    it { should validate_presence_of(:total_copies) }
    it { should validate_uniqueness_of(:isbn) }
    it { should validate_numericality_of(:total_copies).only_integer.is_greater_than_or_equal_to(0) }
    it { should validate_numericality_of(:available_copies).only_integer.is_greater_than_or_equal_to(0) }
  end

  describe 'scopes' do
    before do
      @book1 = create(:book, title: 'Ruby Programming', author: 'Matz', genre: 'Technical')
      @book2 = create(:book, title: 'The Hobbit', author: 'Tolkien', genre: 'Fantasy')
      @book3 = create(:book, available_copies: 0)
    end

    describe '.search_by_title' do
      it 'returns books matching the title' do
        results = Book.search_by_title('Ruby')
        expect(results).to include(@book1)
        expect(results).not_to include(@book2)
      end
    end

    describe '.search_by_author' do
      it 'returns books matching the author' do
        results = Book.search_by_author('Matz')
        expect(results).to include(@book1)
        expect(results).not_to include(@book2)
      end
    end

    describe '.search_by_genre' do
      it 'returns books matching the genre' do
        results = Book.search_by_genre('Fantasy')
        expect(results).to include(@book2)
        expect(results).not_to include(@book1)
      end
    end

    describe '.available' do
      it 'returns only available books' do
        results = Book.available
        expect(results).to include(@book1, @book2)
        expect(results).not_to include(@book3)
      end
    end
  end

  describe '#available?' do
    it 'returns true if available_copies > 0' do
      book = build(:book, available_copies: 5)
      expect(book.available?).to be true
    end

    it 'returns false if available_copies <= 0' do
      book = build(:book, available_copies: 0)
      expect(book.available?).to be false
    end
  end

  describe '#borrow_by_user' do
    let(:book) { create(:book, available_copies: 5) }
    let(:user) { create(:user) }

    it 'creates a borrow record if conditions are met' do
      expect {
        book.borrow_by_user(user)
      }.to change(Borrow, :count).by(1)
    end

    it 'returns nil if user already borrowed the book' do
      create(:borrow, book: book, user: user, returned_at: nil)
      result = book.borrow_by_user(user)
      expect(result).to be_nil
    end

    it 'returns nil if book is not available' do
      book.update(available_copies: 0)
      result = book.borrow_by_user(user)
      expect(result).to be_nil
    end
  end

  describe '#already_borrowed_by?' do
    let(:book) { create(:book) }
    let(:user) { create(:user) }

    it 'returns true if user has active borrow' do
      create(:borrow, book: book, user: user, returned_at: nil)
      expect(book.already_borrowed_by?(user)).to be true
    end

    it 'returns false if user has no active borrow' do
      expect(book.already_borrowed_by?(user)).to be false
    end

    it 'returns false if user has returned the book' do
      create(:borrow, book: book, user: user, returned_at: 1.day.ago)
      expect(book.already_borrowed_by?(user)).to be false
    end
  end

  describe '#current_borrower' do
    let(:book) { create(:book) }
    let(:user) { create(:user) }

    it 'returns the active borrow record for a user' do
      borrow = create(:borrow, book: book, user: user, returned_at: nil)
      expect(book.current_borrower(user)).to eq(borrow)
    end

    it 'returns nil if user has no active borrow' do
      expect(book.current_borrower(user)).to be_nil
    end
  end
end
