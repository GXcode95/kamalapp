class ChatroomsController < ApplicationController
  before_action :set_chatroom, only: %i[show destroy]

  def index
    @chatrooms = Chatroom.all
  end

  def show
    @messages = @chatroom.messages
  end

  def new
    @user = User.find(params[:user_id])
    @chatroom = Chatroom.find_or_create_by(name: chatroom_name(current_user, @user))
    redirect_to @chatroom
  end

  def create
    @chatroom = Chatroom.new(chatroom_params)
    if @chatroom.save
      redirect_to @chatroom, notice: 'Chatroom was successfully created.'
    else
      render :new
    end
  end

  def destroy
    @chatroom.destroy
    redirect_to chatrooms_url, notice: 'Chatroom was successfully destroyed.'
  end

  private

  def set_chatroom
    @chatroom = Chatroom.find(params[:id])
  end

  def chatroom_params
    params.require(:chatroom).permit(:name)
  end

  def chatroom_name(user1, user2)
    [user1.email, user2.email].sort.join("-")
  end
end