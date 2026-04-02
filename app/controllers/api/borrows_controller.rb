class Api::BorrowsController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :api_authenticate_user!
  before_action :set_book, only: [:create]
  before_action :set_borrow, only: [:show, :return_book]

  # GET /api/borrows
  def index
    if current_user.librarian?
      @borrows = Borrow.all.includes(:user, :book)
    else
      @borrows = current_user.borrows.includes(:book)
    end

    @borrows = @borrows.page(params[:page]).per(20)
    render json: @borrows, include: [:user, :book], status: :ok
  end

  # GET /api/borrows/:id
  def show
    render json: @borrow, include: [:user, :book], status: :ok
  end

  # POST /api/borrows
  # Create a new borrow (member borrows a book)
  def create
    @borrow = Borrow.new(borrow_params)
    @borrow.user = current_user
    @borrow.book = @book
    @borrow.borrowed_at = Time.current
    @borrow.due_at = 2.weeks.from_now

    if @book.available? && !@book.already_borrowed_by?(current_user)
      if @borrow.save
        @book.decrement!(:available_copies)
        render json: @borrow, include: :book, status: :created
      else
        render json: { errors: @borrow.errors.full_messages }, status: :unprocessable_entity
      end
    else
      if @book.already_borrowed_by?(current_user)
        render json: { error: 'You have already borrowed this book' }, status: :unprocessable_entity
      else
        render json: { error: 'Book is not available' }, status: :unprocessable_entity
      end
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Book not found' }, status: :not_found
  end

  # PATCH/PUT /api/borrows/:id/return
  # Return a borrowed book
  def return_book
    authorize_librarian!

    if @borrow.returned_at.nil?
      @borrow.return_book
      render json: @borrow, status: :ok
    else
      render json: { error: 'Book already returned' }, status: :unprocessable_entity
    end
  end

  # GET /api/borrows/overdue
  # Get all overdue books
  def overdue
    @borrows = Borrow.overdue.includes(:user, :book)
    render json: @borrows, include: [:user, :book], status: :ok
  end

  # GET /api/borrows/due-today
  # Get books due today
  def due_today
    @borrows = Borrow.due_today.includes(:user, :book)
    render json: @borrows, include: [:user, :book], status: :ok
  end

  private

  def set_book
    @book = Book.find(params[:book_id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Book not found' }, status: :not_found
  end

  def set_borrow
    @borrow = Borrow.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Borrow record not found' }, status: :not_found
  end

  def borrow_params
    params.permit(:book_id)
  end
end
