class UsersController < ApplicationController
  def payment
    friend = User.find(user_params[:friend_id])
    User.find(params[:id]).send_payment(friend, user_params[:amount].to_i, user_params[:description])

    render json: {}, status: 200
  rescue User::PaymentAmountOutOfBounds, User::NonFriendPaymentAttempt => e
    render json: { error: e.message }, status: 400
  end

  private

  def user_params
    params.permit(:friend_id, :amount, :description)
  end
end