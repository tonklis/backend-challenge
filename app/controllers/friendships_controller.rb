class FriendshipsController < ApplicationController

  def create
    begin
      @friendship = Friendship.new
      @friendship.member = Member.find(friendship_params[:member_id])
      @friendship.friend = Member.find(friendship_params[:friend_id])
      if @friendship.save
        render :create, status: :created
      else
        render_400_error
      end
    rescue StandardError => e
      render_500_error(e)
    end
  end

  private

  def friendship_params
    params.require(:friendship).permit(:member_id, :friend_id)
  end

  def render_400_error
    render json: { errors: @friendship.errors.full_messages },
      status: :unprocessable_entity
  end

  def render_500_error(e)
    @friendship = Friendship.new if @friendship.nil?
    @friendship.errors.add(:error_creating_friendship, e)
    render json: { errors: @friendship.errors.full_messages }, status: 500
  end

end
