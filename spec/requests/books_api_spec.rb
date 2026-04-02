require 'rails_helper'

RSpec.describe 'Books API', type: :request do
  let(:librarian) { create(:user, user_type: :librarian) }
  let(:member) { create(:user) }

  describe 'GET /api/books' do
    before { create_list(:book, 3) }

    it 'returns all books' do
      sign_in member
      get '/api/books'

      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response.length).to eq(3)
    end

    it 'requires authentication' do
      get '/api/books'

      expect(response).to have_http_status(:unauthorized)
      json_response = JSON.parse(response.body)
      expect(json_response['error']).to eq('Authentication required')
    end
  end

  describe 'GET /api/books/:id' do
    let(:book) { create(:book) }

    it 'returns a specific book' do
      sign_in member
      get "/api/books/#{book.id}"

      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response['id']).to eq(book.id)
      expect(json_response['title']).to eq(book.title)
    end

    it 'returns 404 for non-existent book' do
      sign_in member
      get '/api/books/9999'

      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'POST /api/books' do
    let(:book_params) do
      {
        book: {
          title: 'New Book',
          author: 'Author Name',
          genre: 'Fiction',
          isbn: '123-456-789-0',
          total_copies: 5
        }
      }
    end

    context 'as librarian' do
      it 'creates a new book' do
        sign_in librarian

        expect {
          post '/api/books', params: book_params
        }.to change(Book, :count).by(1)

        expect(response).to have_http_status(:created)
        json_response = JSON.parse(response.body)
        expect(json_response['title']).to eq('New Book')
      end
    end

    context 'as member' do
      it 'returns forbidden' do
        sign_in member
        post '/api/books', params: book_params

        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'with invalid parameters' do
      it 'returns unprocessable entity' do
        sign_in librarian
        invalid_params = {
          book: {
            title: 'New Book'
          }
        }

        post '/api/books', params: invalid_params

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PATCH /api/books/:id' do
    let(:book) { create(:book) }
    let(:update_params) do
      {
        book: {
          title: 'Updated Title',
          total_copies: 10
        }
      }
    end

    context 'as librarian' do
      it 'updates a book' do
        sign_in librarian
        patch "/api/books/#{book.id}", params: update_params

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response['title']).to eq('Updated Title')
        expect(json_response['total_copies']).to eq(10)
      end
    end

    context 'as member' do
      it 'returns forbidden' do
        sign_in member
        patch "/api/books/#{book.id}", params: update_params

        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'DELETE /api/books/:id' do
    let(:book) { create(:book) }

    context 'as librarian' do
      it 'deletes a book' do
        sign_in librarian

        delete "/api/books/#{book.id}"

        expect(response).to have_http_status(:ok)
        expect(Book.exists?(book.id)).to be false
      end
    end

    context 'as member' do
      it 'returns forbidden' do
        sign_in member
        delete "/api/books/#{book.id}"

        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'GET /api/books/search?q=query' do
    before do
      create(:book, title: 'Ruby Programming', author: 'Matz', genre: 'Technical')
      create(:book, title: 'The Hobbit', author: 'Tolkien', genre: 'Fantasy')
    end

    it 'searches by title' do
      sign_in member
      get '/api/books/search', params: { q: 'Ruby', type: 'title' }

      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response.length).to eq(1)
      expect(json_response[0]['title']).to include('Ruby')
    end

    it 'searches by author' do
      sign_in member
      get '/api/books/search', params: { q: 'Tolkien', type: 'author' }

      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response.length).to eq(1)
      expect(json_response[0]['author']).to eq('Tolkien')
    end

    it 'searches by genre' do
      sign_in member
      get '/api/books/search', params: { q: 'Fantasy', type: 'genre' }

      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response.length).to eq(1)
      expect(json_response[0]['genre']).to eq('Fantasy')
    end
  end

  describe 'GET /api/books/available' do
    before do
      create(:book, available_copies: 5)
      create(:book, available_copies: 0)
    end

    it 'returns only available books' do
      sign_in member
      get '/api/books/available'

      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response.length).to eq(1)
      expect(json_response[0]['available_copies']).to be > 0
    end
  end
end
