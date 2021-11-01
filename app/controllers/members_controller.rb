class MembersController < ApplicationController

  def index
    # counting friendships and extended friendships in view
    begin
      @members = Member.all
    rescue StandardError => e
      render json: { errors: ["Error getting all members"] }, status: 500
    end
  end

  def show
    begin
      @member = Member.includes(:topics, friendships: :friend, extended_friendships: :member).find(params[:id])
    rescue StandardError => e
      render_500_error(e)
    end
  end

  def create
    begin
      @member = Member.new(member_params)
      if @member.save
        render :show, status: :created
      else
        render_400_error
      end
    rescue StandardError => e
      render_500_error(e)
    end
  end

  private

  def member_params
    params.require(:member).permit(:first_name, :last_name, :url)
  end

  def render_400_error
    render json: { errors: @member.errors.full_messages },
      status: :unprocessable_entity
  end

  def render_500_error(e)
    @member = Member.new if @member.nil?
    @member.errors.add(:error_creating_friendship, e)
    render json: { errors: @member.errors.full_messages }, status: 500
  end

end
