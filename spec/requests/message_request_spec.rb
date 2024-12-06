# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MessagesController, type: :request do
  let!(:user1) { create(:user) }
  let!(:user2) { create(:user) }
  let!(:chatroom) { create(:chatroom, users: [user1, user2]) }
  let!(:message) { create(:message, user: user1, chatroom: chatroom) }

  let(:valid_attributes) { { content: 'This is a content', chatroom_id: message.chatroom.id } }
  let(:unvalid_attributes) { { content: nil, chatroom_id: message.chatroom.id } }

  context 'when user is signed in' do
    before do
      sign_in user1
    end

    describe 'GET show' do
      it 'it assigns @message' do
        get chatroom_message_path(chatroom, message)
        expect(assigns(:message)).to eq(message)
      end

      it 'renders the template show' do
        get chatroom_message_path(chatroom, message)
        expect(response).to render_template(:show)
      end

      it 'returns status code ok' do
        get chatroom_message_path(chatroom, message)
        expect(response).to have_http_status(:ok)
      end
    end

    describe 'GET edit' do
      it 'it assigns @message' do
        get edit_chatroom_message_path(chatroom, message)
        expect(assigns(:message)).to eq(message)
      end

      it 'renders the template edit' do
        get edit_chatroom_message_path(chatroom, message)
        expect(response).to render_template(:edit)
      end

      it 'returns status code ok' do
        get edit_chatroom_message_path(chatroom, message)
        expect(response).to have_http_status(:ok)
      end
    end

    describe 'POST create' do
      context 'with valid params' do
        it 'creates a message' do
          params = { message:  valid_attributes }
          expect do
            post chatroom_messages_path(chatroom, format: :turbo_stream), params: params
          end.to change(Message, :count).by(1)
        end

        it 'responds with turbo_stream' do
          params = { message: valid_attributes }
          post chatroom_messages_path(chatroom, format: :turbo_stream), params: params
          expect(response.media_type).to eq Mime[:turbo_stream]
        end

        it 'returns a turbo_stream tag with update action' do
          params = { message: valid_attributes }
          post chatroom_messages_path(chatroom, format: :turbo_stream), params: params
          expect(response.body).to include('<turbo-stream action="update" target="new-message">')
        end

        it 'returns a status code found' do
          params = { message: valid_attributes }
          post chatroom_messages_path(chatroom, format: :turbo_stream), params: params
          expect(response).to have_http_status(:ok)
        end
      end

      context 'with unvalid params' do
        it 'does not create record' do
          params = { message: unvalid_attributes }
          expect do
            post chatroom_messages_path(chatroom, format: :turbo_stream), params: params
          end.to change(Message, :count).by(0)
        end

        it 'renders flash' do
          params = { message: unvalid_attributes }
          post chatroom_messages_path(chatroom, format: :turbo_stream), params: params
          expect(response).to render_template('shared/_flashes')
        end

        it 'responds with turbo_stream' do
          params = { message: valid_attributes }
          post chatroom_messages_path(chatroom, format: :turbo_stream), params: params
          expect(response.media_type).to eq Mime[:turbo_stream]
        end

        it 'returns a status code unprocessable_entity' do
          params = { message: unvalid_attributes }
          post chatroom_messages_path(chatroom, format: :turbo_stream), params: params
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    describe 'PUT update' do
      context 'with valid params' do
        it 'update the message' do
          params = { message: valid_attributes }
          put chatroom_message_path(chatroom, message, format: :turbo_stream), params: params
          expect(message.reload.content.to_plain_text).to eq(valid_attributes[:content])
        end

        it 'renders a turbo_stream with replace action' do
          params = { message: valid_attributes }
          put chatroom_message_path(chatroom, message, format: :turbo_stream), params: params
          expect(response.body).to include('') # actioncable handle the visual update
        end

        it 'returns a status code ok' do
          params = { message: valid_attributes }
          put chatroom_message_path(chatroom, message, format: :turbo_stream), params: params
          expect(response).to have_http_status(:ok)
        end
      end

      context 'with unvalid params' do
        it 'does not update message' do
          params = { message: unvalid_attributes }
          expect do
            put chatroom_message_path(chatroom, message, format: :turbo_stream), params: params
          end.to_not change(message, :content)
        end

        it 'renders the template layouts/flash' do
          params = { message: unvalid_attributes }
          put chatroom_message_path(chatroom, message, format: :turbo_stream), params: params
          expect(response).to render_template('shared/_flashes')
        end

        it 'responds with turbo_stream' do
          params = { message: unvalid_attributes }
          put chatroom_message_path(chatroom, message, format: :turbo_stream), params: params
          expect(response.media_type).to eq Mime[:turbo_stream]
        end

        it 'returns a status code unprocessable_entity' do
          params = { message: unvalid_attributes }
          put chatroom_message_path(chatroom, message, format: :turbo_stream), params: params
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    describe 'DELETE destroy' do
      it 'delete the message' do
        delete chatroom_message_path(chatroom, message)
        expect { message.reload }.to raise_error(ActiveRecord::RecordNotFound)
      end

      it 'returns an empty body' do
        delete chatroom_message_path(chatroom, message)
        expect(response.body).to eq('')
      end

      it 'returns a status no_content' do
        delete chatroom_message_path(chatroom, message)
        expect(response).to have_http_status(:no_content)
      end
    end
  end

  context 'when user is not sined in' do
    describe 'GET edit' do
      it 'redirects to sign in' do
        get edit_chatroom_message_path(chatroom, message)
        expect(response).to redirect_to(:new_user_session)
      end
    end

    describe 'GET create' do
      it 'redirects to sign in' do
        post chatroom_messages_path(chatroom)
        expect(response).to redirect_to(:new_user_session)
      end
    end

    describe 'GET update' do
      it 'red1irects to sign in' do
        put chatroom_message_path(chatroom, message)
        expect(response).to redirect_to(:new_user_session)
      end
    end

    describe 'GET destroy' do
      it 'redirects to sign in' do
        delete chatroom_message_path(chatroom, message)
        expect(response).to redirect_to(:new_user_session)
      end
    end
  end
end
