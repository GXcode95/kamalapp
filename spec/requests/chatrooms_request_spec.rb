# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ChatroomsController, type: :request do
  let!(:user1) { create(:user) }
  let!(:user2) { create(:user) }
  let!(:user3) { create(:user) }
  let!(:chatroom) { create(:chatroom, users: [user1, user2]) }

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

    describe 'POST create' do
      context 'when chatroom does not exist' do
        let(:new_chatroom_params) { { user_ids: [user3.id] } }

        it 'creates a new chatroom' do
          expect do
            post chatrooms_path, params: { chatroom: new_chatroom_params }
          end.to change(Chatroom, :count).by(1)
        end

        it 'redirects to the new chatroom' do
          post chatrooms_path, params: { chatroom: new_chatroom_params }
          expect(response).to redirect_to(Chatroom.last)
        end

        it 'sets a flash success message' do
          post chatrooms_path, params: { chatroom: new_chatroom_params }
          expect(flash[:success]).to eq(I18n.t('flash.actions.create.success', resource_name: Chatroom.model_name.human))
        end
      end

      context 'when chatroom already exists' do
        let(:existing_chatroom_params) { { user_ids: [user1.id, user2.id] } }

        it 'does not create a new chatroom' do
          expect do
            post chatrooms_path, params: { chatroom: existing_chatroom_params }
          end.to_not change(Chatroom, :count)
        end

        it 'redirects to chatroom path' do
          post chatrooms_path, params: { chatroom: existing_chatroom_params }
          expect(response).to redirect_to(chatroom)
        end
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
