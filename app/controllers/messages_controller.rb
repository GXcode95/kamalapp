# frozen_string_literal: true

class MessagesController < ApplicationController
  load_and_authorize_resource except: :create

  before_action :set_chatroom, only: :create

  def show; end

  def edit; end

  def create
    @message = @chatroom.messages.new(message_params.merge(user: current_user))

    authorize! :create, @message
    return if @message.save

    render :new, status: :unprocessable_entity
  end

  def update
    if @message.update(message_params)
      flash.now[:success] = I18n.t('flash.actions.update.success', resource_name: Message.model_name.human)
    else
      flash[:error] = I18n.t('flash.actions.update.error', resource_name: Message.model_name.human)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    return unless @message.destroy

    flash.now[:success] = I18n.t('flash.actions.destroy.success', resource_name: Message.model_name.human)
  end

  private

  def set_chatroom
    @chatroom = Chatroom.find(params[:chatroom_id])
  end

  def message_params
    params.require(:message).permit(:content)
  end
end
