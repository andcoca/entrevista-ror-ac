require 'rails_helper'

RSpec.describe 'Authentication', type: :request do
  describe 'POST /auth/register' do
    let(:user_params) do
      {
        user: {
          name: 'John Doe',
          email: 'john@example.com',
          password: 'password123',
          password_confirmation: 'password123'
        }
      }
    end

    context 'with valid parameters' do
      it 'creates a new user with member type' do
        expect {
          post '/auth/register', params: user_params
        }.to change(User, :count).by(1)

        expect(response).to have_http_status(:created)
        json_response = JSON.parse(response.body)
        expect(json_response['message']).to eq('User registered successfully')
        expect(json_response['user']['user_type']).to eq('member')
      end

      it 'returns user data' do
        post '/auth/register', params: user_params

        json_response = JSON.parse(response.body)
        expect(json_response['user']['name']).to eq('John Doe')
        expect(json_response['user']['email']).to eq('john@example.com')
      end
    end

    context 'with invalid parameters' do
      it 'does not create user with duplicate email' do
        create(:user, email: 'john@example.com')

        expect {
          post '/auth/register', params: user_params
        }.not_to change(User, :count)

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'does not create user without email' do
        invalid_params = user_params.deep_dup
        invalid_params[:user].delete(:email)

        expect {
          post '/auth/register', params: invalid_params
        }.not_to change(User, :count)

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'does not create user with mismatched password confirmation' do
        invalid_params = user_params.deep_dup
        invalid_params[:user][:password_confirmation] = 'different'

        expect {
          post '/auth/register', params: invalid_params
        }.not_to change(User, :count)

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'POST /auth/login' do
    let(:user) { create(:user, password: 'password123') }
    let(:login_params) do
      {
        user: {
          email: user.email,
          password: 'password123'
        }
      }
    end

    context 'with valid credentials' do
      it 'logs in the user' do
        post '/auth/login', params: login_params

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response['message']).to eq('Login successful')
      end

      it 'returns user data' do
        post '/auth/login', params: login_params

        json_response = JSON.parse(response.body)
        expect(json_response['user']['email']).to eq(user.email)
        expect(json_response['user']['name']).to eq(user.name)
      end
    end

    context 'with invalid credentials' do
      it 'returns unauthorized error with wrong password' do
        invalid_params = login_params.deep_dup
        invalid_params[:user][:password] = 'wrongpassword'

        post '/auth/login', params: invalid_params

        expect(response).to have_http_status(:unauthorized)
        json_response = JSON.parse(response.body)
        expect(json_response['error']).to eq('Invalid credentials')
      end

      it 'returns unauthorized error with non-existent email' do
        invalid_params = login_params.deep_dup
        invalid_params[:user][:email] = 'nonexistent@example.com'

        post '/auth/login', params: invalid_params

        expect(response).to have_http_status(:unauthorized)
        json_response = JSON.parse(response.body)
        expect(json_response['error']).to eq('Invalid credentials')
      end
    end
  end

  describe 'POST /auth/logout' do
    let(:user) { create(:user) }

    it 'logs out the user' do
      # Sign in first
      sign_in user

      post '/auth/logout'

      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response['message']).to eq('Logged out successfully')
    end
  end
end
