class BooksController < ApplicationController
  before_action :set_book, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /books
  def index
    @books = Book.all

    if params[:q].present?
      search_type = params[:search_type] || 'title'
      case search_type
      when 'author'
        @books = @books.search_by_author(params[:q])
      when 'genre'
        @books = @books.search_by_genre(params[:q])
      else
        @books = @books.search_by_title(params[:q])
      end
    end
  end

  # GET /books/:id
  def show
  end

  # GET /books/new
  def new
    authorize_librarian!
    @book = Book.new
  end

  # POST /books
  def create
    authorize_librarian!
    @book = Book.new(book_params)

    if @book.save
      redirect_to @book, notice: 'Book added successfully'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # GET /books/:id/edit
  def edit
    authorize_librarian!
  end

  # PATCH/PUT /books/:id
  def update
    authorize_librarian!

    if @book.update(book_params)
      redirect_to @book, notice: 'Book updated successfully'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /books/:id
  def destroy
    authorize_librarian!
    @book.destroy
    redirect_to books_url, notice: 'Book deleted successfully'
  end

  private

  def set_book
    @book = Book.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to books_url, alert: 'Book not found'
  end

  def book_params
    params.require(:book).permit(:title, :author, :genre, :isbn, :total_copies)
  end
end
