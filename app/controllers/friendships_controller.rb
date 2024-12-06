# frozen_string_literal: true

class FriendshipsController < ApplicationController
  load_and_authorize_resource

  def index
    @accepted_friendships = current_user.friendships.accepted
    @pending_friendships = current_user.friendships.pending
  end

  def create
    @friendship = Friendship.find_by(user: current_user, friend: params[:friend_id])
    if @friendship
      @friendship.status = :accepted
    else
      @friendship = Friendship.new(friend_id: params[:friend_id], user_id: current_user.id, status: :accepted)
    end

    if @friendship.save
      flash.now[:success] = t('flash.actions.create.success', resource_name: Friendship.model_name.human)
      return
    end

    flash.now[:error] = t('flash.actions.create.error', resource_name: Friendship.model_name.human)
    redirect_to users_path, error: t('flash.actions.create.error', resource_name: Friendship.model_name.human)
  end

  def update
    if @friendship.update(status: :accepted)
      flash.now[:success] = t('flash.actions.update.success', resource_name: Friendship.model_name.human)
    else
      flash.now[:error] = t('flash.actions.update.error', resource_name: Friendship.model_name.human)
    end
  end

  def destroy
    flash.now[:success] = t('flash.actions.destroy.success', resource_name: Friendship.model_name.human)
    @friendship.destroy
  end
end
