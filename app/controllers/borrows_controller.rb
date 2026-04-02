class BorrowsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_book, only: [:create]
  before_action :set_borrow, only: [:update]

  # POST /books/:book_id/borrows
  def create
    @book = Book.find(params[:book_id])

    unless @book.available?
      return redirect_to book_path(@book), alert: 'Book is not available for borrowing'
    end

    if @book.already_borrowed_by?(current_user)
      return redirect_to book_path(@book), alert: 'You have already borrowed this book'
    end

    @borrow = @book.borrow_by_user(current_user)

    if @borrow
      redirect_to dashboard_path, notice: 'Book borrowed successfully'
    else
      redirect_to book_path(@book), alert: 'Unable to borrow book'
    end
  end

  # PATCH /borrows/:id
  def update
    authorize_librarian! if current_user != @borrow.user

    if params[:returned] == 'true' || params[:returned] == true
      @borrow.return_book
      redirect_to dashboard_path, notice: 'Book marked as returned successfully'
    else
      redirect_to dashboard_path, alert: 'Unable to update borrow record'
    end
  end

  private

  def set_book
    @book = Book.find(params[:book_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to books_url, alert: 'Book not found'
  end

  def set_borrow
    @borrow = Borrow.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to books_url, alert: 'Borrow record not found'
  end
end
