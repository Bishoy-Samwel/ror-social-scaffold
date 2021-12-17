class UsersController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :authorize_request, only: :create
  protect_from_forgery with: :null_session, only: [:create]
  def index
    @users = User.all
    @pending_friends = current_user.pending_requests
    @requesting_friends = current_user.friend_requests
  end

  def create
    user = User.create!(user_params)
    auth_token = AuthenticateUser.new(user.email, user.password).call
    response = { message: Message.account_created, auth_token: auth_token }
    json_response(response, :created)
  end

  def user_params
    params.permit(
      :name,
      :email,
      :password,
      :password_confirmation
    )
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.ordered_by_most_recent
  end

  def send_request
    current_user.send_request(User.find(params[:user_id]))
    redirect_to user_path(current_user), flash: { success: 'request sent' }
  end

  def confirm_request
    current_user.confirm_request(User.find(params[:sender_id]))
    redirect_to user_path(current_user), flash: { success: 'you have confirmed the friend request' }
  end

  def reject_request
    current_user.reject_request(User.find(params[:sender_id]))
    redirect_to user_path(current_user), flash: { success: 'you have rejected the friend request' }
  end
end
