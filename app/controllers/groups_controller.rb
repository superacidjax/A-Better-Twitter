class GroupsController < ApplicationController
  before_filter :signed_in_user, only: [:create, :destroy]
  before_filter :the_right_user, only: :destroy

  expose(:group)

  def create
    group = current_user.groups.build(params[:group])
    if group.save
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
      flash[:warning] = "Hack the planet! (nice try, but no cigar..)"
      redirect_to root_path if group.nil?
    end
end
