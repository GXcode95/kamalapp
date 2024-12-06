# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FriendshipsController, type: :request do
  let!(:user1) { create(:user) }
  let!(:user2) { create(:user) }
  let!(:user3) { create(:user) }
  let!(:user4) { create(:user) }

  let!(:pending_friendship_user1_user2_sent) { create(:accepted_friendship, user: user1, friend: user2) }
  let!(:pending_friendship_user2_user1_received) { pending_friendship_user1_user2_sent.reciprocal_friendship }

  let!(:pending_friendship_user3_user1_sent) { create(:pending_friendship, user: user3, friend: user1) }
  let!(:pending_friendship_user1_user3_received) { pending_friendship_user3_user1_sent.reciprocal_friendship }

  context 'when user is signed in' do
    before do
      sign_in user1
    end

    describe 'GET index' do
      it 'assigns @accepted_friendships' do
        get friendships_path
        expect(assigns(:accepted_friendships)).to eq([pending_friendship_user1_user2_sent])
      end

      it 'assigns @pending_friendships' do
        get friendships_path
        expect(assigns(:pending_friendships)).to eq([pending_friendship_user1_user3_received])
      end

      it 'renders the index template' do
        get friendships_path
        expect(response).to render_template(:index)
      end

      it 'returns status code ok' do
        get friendships_path
        expect(response).to have_http_status(:ok)
      end
    end

    describe 'POST create' do
      context 'when friendship does not exist' do
        let(:new_friendship_params) { { friend_id: user4.id } }

        it 'creates a new friendship and the reciprocal friendship' do
          expect do
            post friendships_path(format: :turbo_stream), params: new_friendship_params
          end.to change(Friendship, :count).by(2)
        end

        it 'returns a turbo_stream tag with update action' do
          post friendships_path(format: :turbo_stream), params: new_friendship_params
          expect(response.body).to include("<turbo-stream action=\"update\" target=\"user_#{user4.id}\"")
        end

        it 'renders flashes' do
          post friendships_path(format: :turbo_stream), params: new_friendship_params
          expect(response).to render_template('shared/_flashes')
        end
      end

      context 'when friendship already exists' do
        let(:existing_friendship_params) { { friend_id: user3.id } }

        it 'do not create the friendship' do
          expect do
            post friendships_path(format: :turbo_stream), params: existing_friendship_params
          end.to change(Friendship, :count).by(0)
        end

        it 'accept the friendship' do
          post friendships_path(format: :turbo_stream), params: existing_friendship_params
          expect(pending_friendship_user1_user3_received.reload.status).to eq('accepted')
        end

        it 'renders flashes' do
          post friendships_path(format: :turbo_stream), params: existing_friendship_params
          expect(response).to render_template('shared/_flashes')
        end

        it 'returns a turbo_stream tag with update action' do
          post friendships_path(format: :turbo_stream), params: existing_friendship_params
          expect(response.body).to include("<turbo-stream action=\"update\" target=\"user_#{user3.id}\"")
        end
      end
    end

    describe 'PATCH update' do
      context 'when user owns the friendship' do
        it 'accept the friendship' do
          patch friendship_path(pending_friendship_user1_user3_received, format: :turbo_stream)
          expect(pending_friendship_user1_user3_received.reload.status).to eq('accepted')
        end

        it 'returns a turbo_stream tag with update action for friendship' do
          patch friendship_path(pending_friendship_user1_user3_received, format: :turbo_stream)
          expect(response.body).to(
            include("<turbo-stream action=\"update\" target=\"friendship_#{pending_friendship_user1_user3_received.id}\"")
          )
        end

        it 'returns a turbo_stream tag with update action for user' do
          patch friendship_path(pending_friendship_user1_user3_received, format: :turbo_stream)
          expect(response.body).to(
            include("<turbo-stream action=\"update\" target=\"friendship_#{pending_friendship_user1_user3_received.id}\"")
          )
        end

        it 'renders flashes' do
          patch friendship_path(pending_friendship_user1_user3_received, format: :turbo_stream)
          expect(response).to render_template('shared/_flashes')
        end
      end

      context 'when user does not own the friendship' do
        it 'raise permission error' do
          expect do
            patch friendship_path(pending_friendship_user3_user1_sent, format: :turbo_stream)
          end.to raise_error(CanCan::AccessDenied)
        end
      end
    end

    describe 'DELETE destroy' do
      context 'when user owns the friendship' do
        it 'delete the friendship' do
          delete friendship_path(pending_friendship_user1_user2_sent, format: :turbo_stream)
          expect { pending_friendship_user1_user2_sent.reload }.to raise_error(ActiveRecord::RecordNotFound)
        end

        it 'delete the reciprocal friendship friendship' do
          delete friendship_path(pending_friendship_user1_user2_sent, format: :turbo_stream)
          expect { pending_friendship_user1_user2_sent.reload.reciprocal_friendship }.to raise_error(ActiveRecord::RecordNotFound)
        end

        it 'returns a turbo_stream tag with remove action' do
          delete friendship_path(pending_friendship_user1_user2_sent, format: :turbo_stream)
          expect(response.body).to(
            include("<turbo-stream action=\"remove\" target=\"friendship_#{pending_friendship_user1_user2_sent.id}\"")
          )
        end

        it 'renders flashes' do
          delete friendship_path(pending_friendship_user1_user2_sent, format: :turbo_stream)
          expect(response).to render_template('shared/_flashes')
        end
      end

      context 'when user does not own the friendship' do
        it 'raise permission error' do
          expect do
            patch friendship_path(pending_friendship_user3_user1_sent, format: :turbo_stream)
          end.to raise_error(CanCan::AccessDenied)
        end
      end
    end
  end

  context 'when user isn\'t signed in' do
    describe 'GET index' do
      it 'redirects to the sign_in page' do
        get friendships_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe 'POST create' do
      it 'redirects to the sign_in page' do
        post friendships_path(friend_id: user1.id)
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe 'PATCH update' do
      it 'redirects to the sign_in page' do
        patch friendship_path(Friendship.last)
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe 'DELETE destroy' do
      it 'redirects to the sign_in page' do
        delete friendship_path(Friendship.last)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
