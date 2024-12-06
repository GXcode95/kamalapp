# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ChatroomsController, type: :request do
  let!(:user1) { create(:user) }
  let!(:user2) { create(:user) }
  let!(:friendship_user1_user2) { create(:accepted_friendship, user: user1, friend: user2) }
  let!(:friendship_user2_user1) { friendship_user1_user2.reciprocal_friendship.update(status: :accepted) }
  let!(:chatroom) { Chatroom.with_users([user1, user2]) }

  let!(:user3) { create(:user) }

  context 'when user is signed in' do
    before do
      sign_in user1
    end

    describe 'GET index' do
      it 'assigns @chatrooms' do
        get chatrooms_path
        expect(assigns(:chatrooms)).to eq([chatroom])
      end

      it 'renders the index template' do
        get chatrooms_path
        expect(response).to render_template(:index)
      end

      it 'returns status code ok' do
        get chatrooms_path
        expect(response).to have_http_status(:ok)
      end
    end

    describe 'GET show' do
      it 'assigns @chatroom' do
        get chatroom_path(chatroom)
        expect(assigns(:chatroom)).to eq(chatroom)
      end

      it 'renders the show template' do
        get chatroom_path(chatroom)
        expect(response).to render_template(:show)
      end

      it 'returns status code ok' do
        get chatroom_path(chatroom)
        expect(response).to have_http_status(:ok)
      end
    end
  end

  context 'when user isn\'t signed in' do
    describe 'GET index' do
      it 'redirects to the sign_in page' do
        get chatrooms_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe 'GET show' do
      it 'redirects to the sign_in page' do
        get chatroom_path(chatroom)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
