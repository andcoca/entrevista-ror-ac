class Api::BooksController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :api_authenticate_user!
  before_action :authorize_librarian!, except: [:index, :show, :search, :available]
  before_action :set_book, only: [:show, :update, :destroy]

  # GET /api/books
  def index
    @books = Book.all.page(params[:page]).per(20)
    render json: @books, status: :ok
  end

  # GET /api/books/:id
  def show
    render json: @book, status: :ok
  end

  # POST /api/books
  def create
    @book = Book.new(book_params)

    if @book.save
      render json: @book, status: :created
    else
      render json: { errors: @book.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/books/:id
  def update
    if @book.update(book_params)
      render json: @book, status: :ok
    else
      render json: { errors: @book.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /api/books/:id
  def destroy
    @book.destroy
    render json: { message: 'Book deleted successfully' }, status: :ok
  end

  # GET /api/books/search?q=query&type=title|author|genre
  def search
    query = params[:q]
    search_type = params[:type] || 'title'

    case search_type
    when 'author'
      @books = Book.search_by_author(query)
    when 'genre'
      @books = Book.search_by_genre(query)
    else
      @books = Book.search_by_title(query)
    end

    render json: @books, status: :ok
  end

  # GET /api/books/available
  def available
    @books = Book.available
    render json: @books, status: :ok
  end

  private

  def set_book
    @book = Book.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Book not found' }, status: :not_found
  end

  def book_params
    params.require(:book).permit(:title, :author, :genre, :isbn, :total_copies)
  end
end
