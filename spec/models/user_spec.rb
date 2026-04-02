require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should have_many(:profiles).dependent(:destroy) }
    it { should have_many(:borrows).dependent(:destroy) }
    it { should have_many(:books).through(:borrows) }
  end

  describe 'validations' do
    describe 'email' do
      it 'validates presence of email' do
        user = build(:user, email: nil)
        expect(user).not_to be_valid
        expect(user.errors[:email]).to include("can't be blank")
      end

      it 'validates uniqueness of email' do
        create(:user, email: 'test@example.com')
        user = build(:user, email: 'test@example.com')
        expect(user).not_to be_valid
        expect(user.errors[:email]).to include('has already been taken')
      end
    end

    describe 'name' do
      it 'validates presence of name' do
        user = build(:user, name: nil)
        expect(user).not_to be_valid
        expect(user.errors[:name]).to include("can't be blank")
      end
    end

    describe 'password' do
      it 'validates presence of password on create' do
        user = build(:user, password: nil, password_confirmation: nil)
        expect(user).not_to be_valid
      end

      it 'validates minimum length of password' do
        user = build(:user, password: '123', password_confirmation: '123')
        expect(user).not_to be_valid
      end
    end
  end

  describe '#librarian?' do
    it 'returns true if user_type is librarian' do
      user = build(:user, user_type: :librarian)
      expect(user.librarian?).to be true
    end

    it 'returns false if user_type is member' do
      user = build(:user, user_type: :member)
      expect(user.librarian?).to be false
    end
  end

  describe '#member?' do
    it 'returns true if user_type is member' do
      user = build(:user, user_type: :member)
      expect(user.member?).to be true
    end

    it 'returns false if user_type is librarian' do
      user = build(:user, user_type: :librarian)
      expect(user.member?).to be false
    end
  end

  describe '#overdue_books' do
    it 'returns only overdue borrows' do
      user = create(:user)
      overdue_borrow = create(:borrow, user: user, due_at: 1.day.ago, returned_at: nil)
      active_borrow = create(:borrow, user: user, due_at: 1.day.from_now, returned_at: nil)
      returned_borrow = create(:borrow, user: user, returned_at: 1.day.ago)

      expect(user.overdue_books.count).to eq(1)
      expect(user.overdue_books.first).to eq(overdue_borrow)
    end
  end

  describe '#active_borrows' do
    it 'returns only active borrows' do
      user = create(:user)
      active_borrow = create(:borrow, user: user, returned_at: nil)
      returned_borrow = create(:borrow, user: user, returned_at: 1.day.ago)

      expect(user.active_borrows.count).to eq(1)
      expect(user.active_borrows.first).to eq(active_borrow)
    end
  end
end
