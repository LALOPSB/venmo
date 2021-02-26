class UsersController < ApplicationController
  before_action :find_user

  def payment
    friend = User.find(user_params[:friend_id])
    user.send_payment(friend, user_params[:amount].to_i, user_params[:description])

    render json: {}, status: 200
  rescue User::PaymentAmountOutOfBounds, User::NonFriendPaymentAttempt, ActiveRecordError => e
    render json: { error: e.message }, status: 400
  end

  def balance
    balance = user.payment_account.balance

    render json: { balance_check: balance }, status: 200
  end

  def feed
    feed_items = UserFeedBuilder.new(user, user_params[:page]).execute

    render json: { activity_feed: feed_items }, status: 200
  end

  private

  def find_user
    render json: { error: 'User not found!' }, status: :not_found and return unless user
  end

  def user
    @user ||= User.find_by(id: params[:id])
  end

  def user_params
    params.permit(:friend_id, :amount, :description, :page)
  end
end