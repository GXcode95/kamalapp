# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, type: :request do
  let!(:user1) { create(:user) }
  let!(:user2) { create(:user) }

  context 'when user is signed in' do
    before do
      sign_in user1
    end

    describe 'GET index' do
      it 'assigns @users' do
        get users_path
        expect(assigns(:users)).to eq([user2])
      end

      it 'renders the index template' do
        get users_path
        expect(response).to render_template(:index)
      end

      it 'returns status code ok' do
        get users_path
        expect(response).to have_http_status(:ok)
      end
    end
  end

  context 'when user is not signed in' do
    describe 'GET index' do
      it 'redirects to the sign in page' do
        get users_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
