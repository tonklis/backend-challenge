class MembersController < ApplicationController

  def index
    begin
      # counting friendships and extended friendships in view
      @members = Member.all
    rescue StandardError => e
      render json: { errors: ["Error getting all members"] }, status: 500
    end
  end

  def show
    begin
      # adding associations to avoid n-queries in views
      @member = Member.includes(:topics, :friends, :extended_friends).find(params[:id])
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

  def search
    begin
      topic = params[:topic]
      # friends and extended friends associations used in search algorithm
      @member = Member.includes(:friends, :extended_friends).find(params[:id])
      @paths_per_topic = @member.search(topic)
      render :search, status: :ok
    rescue StandardError => e
      render json: { errors: ["Error performing topic search"] }, status: 500
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
    @member.errors.add(:members_controller_error, e)
    render json: { errors: @member.errors.full_messages }, status: 500
  end

end
