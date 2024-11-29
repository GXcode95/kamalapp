# frozen_string_literal: true

class MessagesController < ApplicationController
  before_action :set_chatroom, only: :create
  before_action :set_message, except: :create

  def show; end

  def edit; end

  def create
    @chatroom = Chatroom.find(params[:chatroom_id])
    @message = @chatroom.messages.build(message_params.merge(user: current_user))

    return if @message.save

    render :new, status: :unprocessable_entity
  end

  def update
    if @message.update(message_params)
      flash.now[:success] = I18n.t('flash.actions.update.success', resource_name: Message.model_name.human)
    else
      flash.now[:error] = I18n.t('flash.actions.update.error', resource_name: Message.model_name.human)
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

  def set_message
    @message = Message.find(params[:id])
  end

  def message_params
    params.require(:message).permit(:content)
  end
end
