class GroupsController < ApplicationController
  before_filter :signed_in_user, only: [:create, :destroy]
  before_filter :the_right_user, only: :destroy

  expose(:group)

  def index
    @groups = Group.paginate(page: params[:page])
  end

  def show
    @group_feed_items = group.notes.paginate(page: params[:page])
  end

  def create
    group = current_user.groups.build(params[:group])
    if group.save
      current_user.join!(group)
      flash[:success] = "Group created!"
      redirect_to root_path
    else
      if group.errors.any?
        flash[:failure] = "I'm sorry! #{group.errors.full_messages}"
      end
      render 'groups/new'
    end
  end

  def destroy
    Group.find(params[:id]).destroy
    flash[:success] = "Group deleted"
    redirect_to root_path
  end

  private

    def the_right_user
      group = current_user.groups.find_by_id(params[:id])
      redirect_to root_path if group.nil?
      flash[:warning] = "Hack the planet! (nice try, but no cigar..)" if group.nil?
    end
end
